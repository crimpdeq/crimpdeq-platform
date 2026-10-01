#!/usr/bin/env python3
"""Build the ready-to-print Bambu Studio project from the model.

Exports every part at its place on its print plate (export-parts.sh with
ON_PLATE=true), checks the plate layout, lets the Bambu Studio CLI assemble
the two plates with the print settings from docs/src/build/printing.md, and
slices the project to confirm that every plate is printable.

Usage: python3 export-bambu-project.py [--output FILE.3mf] [--skip-slice]
BAMBU_STUDIO names the Bambu Studio executable (default: bambu-studio on PATH,
then the macOS application); BAMBU_STUDIO_PROFILES its profiles directory.
OPENSCAD_RENDER_FN and EXPORT_JOBS are passed to export-parts.sh.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent
MACOS_APP = Path("/Applications/BambuStudio.app/Contents/MacOS/BambuStudio")

PRINTER = "Bambu Lab A1 0.4 nozzle"
PROCESS = "0.20mm Standard @BBL A1"
FILAMENT = "Generic PETG @BBL A1"
PROJECT_PROCESS = "Crimpdeq platform @BBL A1"
BED_TYPE = "Textured PEI Plate"

# The print settings table in docs/src/build/printing.md.
PROCESS_OVERRIDES = {
    "layer_height": "0.2",
    "wall_loops": "6",
    "top_shell_layers": "6",
    "bottom_shell_layers": "6",
    "sparse_infill_density": "20%",
    # No part needs support; the joint sockets and the rest's rail groove are
    # bridged, and support in the groove would scar a sliding face.
    "enable_support": "0",
    "brim_type": "outer_only",
    "brim_width": "5",
}
SOLID = {"sparse_infill_density": "100%"}
REST = {"sparse_infill_density": "50%"}
BASE = {"top_shell_layers": "4", "bottom_shell_layers": "4"}
# Height ranges that print parts of an object sparser, as (min Z, max Z,
# settings) with the heights as dynamometer_dimensions.scad expressions in the
# part's print Z. Bambu Studio reads the layer height of every height range.
RANGE_BASE = {"layer_height": PROCESS_OVERRIDES["layer_height"]}
HEIGHT_RANGES = {
    # The phone stand's cheeks, the only part of the front half above the
    # deck, carry only the phone.
    "base_front": [("deck_z - base_z_min", "phone_stand_top_z - base_z_min",
                    {**RANGE_BASE, "sparse_infill_density": "10%"})],
    # The upper heel and the bolster, above the key wings and the rail groove.
    "rest": [("rest_wing_top_z - rest_z_min", "rest_bolster_z_max - rest_z_min",
              {**RANGE_BASE, "sparse_infill_density": "15%"})],
    # The anchor block's lower body only bears on its pocket; its top 5 mm
    # stays solid under the tongue root.
    "anchor": [("0", "deck_z - 5 - anchor_z_min",
                {**RANGE_BASE, "sparse_infill_density": "40%"})],
}

# Bambu Studio drops plate names containing any of ILLEGAL_NAME_CHARS.
PLATES = [
    ("Front base and small parts", [
        ("base_front", BASE), ("grip", SOLID), ("anchor", SOLID), ("clips", SOLID),
        ("keys", SOLID),
    ]),
    ("Rear base, palm rest and stoppers", [
        ("stoppers", {}), ("base_rear", BASE), ("rest", REST),
    ]),
]
ILLEGAL_NAME_CHARS = '<>:/\\|?*"'
# Minimum gap between parts that share a plate (docs/src/build/printing.md).
MIN_PART_GAP = 15.0


def load_stl_reader():
    spec = importlib.util.spec_from_file_location(
        "check_stl_components", PROJECT_ROOT / "check-stl-components.py"
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.read_stl


def find_bambu_studio() -> Path:
    candidate = os.environ.get("BAMBU_STUDIO") or shutil.which("bambu-studio")
    if candidate:
        return Path(candidate)
    if MACOS_APP.exists():
        return MACOS_APP
    sys.exit("Bambu Studio not found: set BAMBU_STUDIO or put bambu-studio on PATH")


def find_profiles(bambu_studio: Path) -> Path:
    if os.environ.get("BAMBU_STUDIO_PROFILES"):
        return Path(os.environ["BAMBU_STUDIO_PROFILES"])
    exe_dir = bambu_studio.resolve().parent
    # macOS bundle, extracted AppImage, installed package.
    for candidate in (
        exe_dir.parent / "Resources" / "profiles",
        exe_dir / "resources" / "profiles",
        exe_dir.parent / "resources" / "profiles",
        exe_dir.parent / "share" / "BambuStudio" / "profiles",
    ):
        if (candidate / "BBL").is_dir():
            return candidate
    sys.exit(f"Bambu Studio profiles not found near {bambu_studio}: set BAMBU_STUDIO_PROFILES")


class Presets:
    """Bambu Lab system presets, flattened along their `inherits` chains."""

    def __init__(self, profiles: Path):
        self.by_name: dict[tuple[str, str], dict] = {}
        for kind in ("machine", "process", "filament"):
            for path in (profiles / "BBL" / kind).rglob("*.json"):
                try:
                    preset = json.loads(path.read_text(encoding="utf-8"))
                except (json.JSONDecodeError, UnicodeDecodeError):
                    continue
                if isinstance(preset, dict) and "name" in preset:
                    self.by_name[(kind, preset["name"])] = preset

    def flattened(self, kind: str, name: str) -> dict:
        preset = self.by_name.get((kind, name))
        if preset is None:
            sys.exit(f"Bambu Studio has no {kind} preset named {name!r}")
        parent = preset.get("inherits")
        resolved = self.flattened(kind, parent) if parent else {}
        resolved.update(preset)
        resolved.pop("inherits", None)
        return resolved


def write_settings(presets: Presets, work: Path) -> tuple[Path, Path, Path]:
    machine = presets.flattened("machine", PRINTER)
    filament = presets.flattened("filament", FILAMENT)
    process = presets.flattened("process", PROCESS)
    for key in ("setting_id", "instantiation"):
        process.pop(key, None)
    # A project preset on top of the system process, so Bambu Studio lists
    # the changed settings against it.
    process.update(PROCESS_OVERRIDES)
    process.update({"name": PROJECT_PROCESS, "inherits": PROCESS, "from": "User"})

    paths = []
    for name, preset in (("machine", machine), ("process", process), ("filament", filament)):
        path = work / f"{name}.json"
        path.write_text(json.dumps(preset, indent=4), encoding="utf-8")
        paths.append(path)
    return paths[0], paths[1], paths[2]


def list_changed_settings(project: Path, presets: Presets) -> None:
    """Record the process overrides in the project's different_settings_to_system.

    When Bambu Studio opens a project whose preset inherits a system preset,
    it keeps only the settings listed there and resets the rest to the system
    values. The CLI leaves the list empty, which would drop every override.
    """
    system = presets.flattened("process", PROCESS)
    changed = sorted(key for key, value in PROCESS_OVERRIDES.items()
                     if system.get(key) not in (value, [value]))
    name = "Metadata/project_settings.config"
    with zipfile.ZipFile(project) as archive:
        entries = [(info, archive.read(info)) for info in archive.infolist()]
    with zipfile.ZipFile(project, "w") as archive:
        for info, data in entries:
            if info.filename == name:
                settings = json.loads(data)
                missing = [key for key in changed if settings.get(key) != PROCESS_OVERRIDES[key]]
                if missing:
                    sys.exit(f"Bambu Studio did not keep the process overrides: {missing}")
                # Process first, then the filament and printer presets.
                settings["different_settings_to_system"][0] = ";".join(changed)
                data = json.dumps(settings, indent=4).encode("utf-8")
            archive.writestr(info, data)


def bed_size(presets: Presets) -> tuple[float, float]:
    corners = [
        tuple(float(v) for v in corner.split("x"))
        for corner in presets.flattened("machine", PRINTER)["printable_area"]
    ]
    return max(x for x, _ in corners), max(y for _, y in corners)


def height_ranges(work: Path) -> dict[str, list[dict]]:
    """HEIGHT_RANGES with their heights evaluated from the model."""
    expressions = [z for ranges in HEIGHT_RANGES.values()
                   for min_z, max_z, _ in ranges for z in (min_z, max_z)]
    probe = work / "height_ranges.scad"
    probe.write_text(
        f"include <{PROJECT_ROOT / 'dynamometer_dimensions.scad'}>\n"
        f"echo(height_ranges = [{', '.join(expressions)}]);\n",
        encoding="utf-8",
    )
    echo = work / "height_ranges.echo"
    subprocess.run(["openscad", "-o", str(echo), str(probe)], check=True,
                   capture_output=True)
    line = next(l for l in echo.read_text().splitlines() if "height_ranges" in l)
    heights = iter(json.loads(line.split("=", 1)[1]))
    return {
        part: [{"min_z": next(heights), "max_z": next(heights), "range_params": params}
               for _, _, params in ranges]
        for part, ranges in HEIGHT_RANGES.items()
    }


def export_parts(stl_dir: Path) -> None:
    env = dict(os.environ, EXPORT_DIR=str(stl_dir), ON_PLATE="true")
    parts = [part for _, objects in PLATES for part, _ in objects]
    subprocess.run(["bash", str(PROJECT_ROOT / "export-parts.sh"), *parts], env=env, check=True)


def stl_path(stl_dir: Path, part: str) -> Path:
    return stl_dir / f"crimpdeq-platform-{part}.stl"


def check_layout(stl_dir: Path, bed: tuple[float, float]) -> None:
    read_stl = load_stl_reader()
    margin = float(PROCESS_OVERRIDES["brim_width"])
    errors = [f"plate name {plate!r} contains one of {ILLEGAL_NAME_CHARS}"
              for plate, _ in PLATES if any(c in ILLEGAL_NAME_CHARS for c in plate)]
    for plate, objects in PLATES:
        boxes = {}
        for part, _ in objects:
            points = [v for tri in read_stl(stl_path(stl_dir, part)) for v in tri]
            lo = [min(p[i] for p in points) for i in range(3)]
            hi = [max(p[i] for p in points) for i in range(3)]
            boxes[part] = (lo, hi)
            print(f"{plate}: {part} X {lo[0]:.1f}..{hi[0]:.1f}, Y {lo[1]:.1f}..{hi[1]:.1f}")
            if abs(lo[2]) > 1e-3:
                errors.append(f"{part} does not rest on the bed (Z min {lo[2]:.3f})")
            if (min(lo[0], lo[1]) < margin or hi[0] > bed[0] - margin
                    or hi[1] > bed[1] - margin):
                errors.append(f"{part} or its {margin:g} mm brim leaves the {bed[0]:g} x {bed[1]:g} mm bed")
        names = list(boxes)
        for i, a in enumerate(names):
            for b in names[i + 1:]:
                (alo, ahi), (blo, bhi) = boxes[a], boxes[b]
                gap = max(blo[0] - ahi[0], alo[0] - bhi[0], blo[1] - ahi[1], alo[1] - bhi[1])
                if gap < MIN_PART_GAP:
                    errors.append(f"{a} and {b} are {gap:.1f} mm apart, under {MIN_PART_GAP:g} mm")
    if errors:
        sys.exit("Plate layout check failed:\n  " + "\n  ".join(errors))


def run_bambu(bambu_studio: Path, args: list[str], out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    proc = subprocess.run(
        [str(bambu_studio), "--debug", "1", *args, "--outputdir", str(out_dir)],
        cwd=out_dir, capture_output=True, text=True,
    )
    # At --debug 1 Bambu Studio logs only errors, such as skipped thumbnails.
    sys.stdout.write(proc.stdout[-8000:])
    sys.stderr.write(proc.stderr[-8000:])
    result_path = out_dir / "result.json"
    result = json.loads(result_path.read_text()) if result_path.exists() else {}
    if proc.returncode != 0 or result.get("return_code", 0) != 0:
        sys.exit(f"Bambu Studio failed ({proc.returncode}): {result.get('error_string', 'no result')}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--output", type=Path,
                        default=PROJECT_ROOT / "exports" / "crimpdeq-platform.3mf")
    parser.add_argument("--skip-slice", action="store_true",
                        help="don't slice the project to check it")
    args = parser.parse_args()

    bambu_studio = find_bambu_studio()
    presets = Presets(find_profiles(bambu_studio))

    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        stl_dir = work / "stl"
        export_parts(stl_dir)
        check_layout(stl_dir, bed_size(presets))

        machine, process, filament = write_settings(presets, work)
        ranges = height_ranges(work)
        assemble_list = {
            "plates": [
                {
                    "plate_name": plate,
                    "need_arrange": False,
                    "plate_params": {"curr_bed_type": BED_TYPE},
                    "objects": [
                        {
                            "path": str(stl_path(stl_dir, part)),
                            "count": 1,
                            "filaments": [1],
                            "print_params": params,
                            "height_ranges": ranges.get(part, []),
                        }
                        for part, params in objects
                    ],
                }
                for plate, objects in PLATES
            ]
        }
        assemble_path = work / "assemble.json"
        assemble_path.write_text(json.dumps(assemble_list, indent=4), encoding="utf-8")

        project = work / "project" / args.output.name
        run_bambu(bambu_studio, [
            "--load-settings", f"{machine};{process}",
            "--load-filaments", str(filament),
            "--load-assemble-list", str(assemble_path),
            "--export-3mf", project.name,
        ], project.parent)
        list_changed_settings(project, presets)
        if not args.skip_slice:
            run_bambu(bambu_studio, ["--slice", "0", str(project)], work / "slice")
            print("Sliced every plate without errors")

        args.output.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(project, args.output)
    print(f"Exported {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
