# Agent Instructions

## Project scope

- This is a standalone OpenSCAD project; do not add runtime dependencies on
  [crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case);
  `check-real-case.sh` is the only optional integration check against it.
- `crimpdeq_reference.scad` is a local fit/collision reference of
  crimpdeq-case `v2.0.0`, not a replacement enclosure design; run
  `check-real-case.sh` against that tag.
- Keep all dimensions in millimetres and forces in newtons.

## Design requirements

- `docs/src/design/requirements.md` lists the design requirements. Preserve
  every one; if a change needs to break one, explain the impact and ask
  before implementing it, then update that page with the model.

## File responsibilities

- `dynamometer_dimensions.scad`: shared parameters, derived dimensions, and
  structural assertions.
- `dynamometer_parts.scad`: printable base, anchor, grip, clip, rest, key
  and stopper modules, and the phone stand, without top-level geometry.
- `dynamometer_assembly.scad`: preview and STL export entry point.
- `crimpdeq_reference.scad`: self-contained crimpdeq-case `v2.0.0`
  interface snapshot.
- `collision_check.scad`: individual intersection probes selected by `mode`.
- `check-collisions.sh`: complete geometry and STL connectivity validation.
- `check-stl-components.py`: connected-component check used by
  `check-collisions.sh`.
- `check-real-case.sh`: optional clearance check against the sibling
  `crimpdeq-case` source.
- `export-parts.sh`: exports every printable part; used by the release
  workflow.
- `export-bambu-project.py`: builds and slice-checks the two-plate Bambu
  Studio project from the plate layout in `print_plate_placement()`; used
  by the release workflow.
- `fonts/`: the bundled Inter Bold used by the brand engraving, with its
  OFL license.
- `.github/workflows/`: CI checks, release STL publication, and a weekly
  OpenSCAD 2021.01 compatibility check.
- `.github/actions/setup-openscad/`: the pinned OpenSCAD snapshot used by CI
  and releases.
- `.github/actions/setup-bambu-studio/`: the pinned Bambu Studio used to
  build the release project.
- `docs/`: mdBook documentation; `docs/src/design/requirements.md` holds
  the design requirements and `docs/illustrations/` renders the images in
  `docs/src/images/` from the model.
- `README.md`: short prose overview; keep details, lists, and figures that
  can go stale in the book.

## OpenSCAD conventions

- Define reusable geometry as modules; only entry-point files should emit
  top-level geometry.
- Use `is_undef(parameter) ? default : parameter` for CLI-overridable values,
  except the view options in `dynamometer_assembly.scad`, which stay
  annotated literals so OpenSCAD's Customizer lists them.
- Use `render_fn` for tessellation and keep validation renders at
  `OPENSCAD_RENDER_FN=24`.
- Add assertions for invalid clearances, collapsed sections, and unsafe
  parameter combinations.
- Update `dynamometer_dimensions.scad` and `crimpdeq_reference.scad` together
  when the Crimpdeq mechanical interface changes.

## Required validation

Run after every geometry or dimension change:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

The command must pass all collision probes and report exactly one connected
component for each single-part STL and two for the paired parts.

Documentation changes must pass `mdbook build docs`. Re-render affected book
illustrations after geometry changes.

Do not add generated STL, 3MF, PNG, or temporary render artifacts to the
project unless explicitly requested. The rendered book illustrations in
`docs/src/images/` are the exception and are committed.
