# Agent Instructions

## Project scope

- This is a standalone OpenSCAD project; do not add runtime dependencies on
  [crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case);
  `check-real-case.sh` is the only optional integration check against it.
- `crimpdeq_reference.scad` is a local fit/collision reference, not a
  replacement enclosure design.
- Keep all dimensions in millimetres and forces in newtons.

## Design invariants

- The load cell is rated for 50 kg (approximately 490 N).
- The printed frame is sized with a 2.0 structural safety factor, but the sensor
  must never be tested above its 50 kg rating.
- Route hand force through both Ø17 mm load-cell eyes, pin spacers, collars,
  and double-shear clevis cheeks.
- Keep the four-finger hangboard pocket exactly 25 mm deep with at least an
  80 mm-wide opening, 6 mm back wall, and 8 mm loading lip.
- Keep its `+Z` opening clear and retain the full-depth left spine joining it
  to both clevis cheeks.
- Keep the drop-in pocket stoppers for 20, 15, and 10 mm edges located by the
  closed pocket walls, and their storage well in the unloaded block outboard
  of the left anchor post.
- Keep the grip-guide ledges under the grip's side walls with a Z gap and
  free X travel, so they catch tilt without carrying measured load.
- Keep the rounded palm/wrist-heel pad beside the hangboard pocket, with its
  heel deck level with the pocket mouth and its palm bolster rising 20 mm
  above it, at least 2 mm above the pin buttons.
- Preserve its nine positively locked 25–105 mm opening positions, with
  discrete holes in the fixed rails, round holes in the pad arms, and two
  tethered Ø6 mm push-button ball-lock pins; adjustment must remain tool-free.
- Size each steel wrist pin for at least 1 kN double-shear capacity, and verify
  both travel extremes after geometry changes.
- Keep each frame half within the 240 mm printable length of a 256 mm bed
  (Bambu Lab A1), joined only by the bolted rail lap joints, so the wrist rest
  can slide onto the right half before the frame is closed.
- Do not use the enclosure shell, lid, or enclosure screws as load-bearing
  members.
- Preserve switch and USB access through the +Y frame service tunnel.
- Keep the phone slot at the left (-X) end, outside the load path and clear
  of the hand at every wrist position.
- Keep the frame, grip, case, and pin interfaces collision-free except for
  explicitly modelled load-cell contact surfaces.

## File responsibilities

- `dynamometer_dimensions.scad`: shared parameters, derived dimensions, and
  structural assertions.
- `dynamometer_parts.scad`: printable frame, grip, wrist-rest, and interface
  modules without top-level geometry.
- `dynamometer_assembly.scad`: preview and STL export entry point.
- `crimpdeq_reference.scad`: self-contained Crimpdeq v2 interface snapshot.
- `collision_check.scad`: individual intersection probes selected by `mode`.
- `check-collisions.sh`: complete geometry and STL connectivity validation.
- `check-stl-components.py`: connected-component check used by
  `check-collisions.sh`.
- `check-real-case.sh`: optional clearance check against the sibling
  `crimpdeq-case` source.
- `export-parts.sh`: exports every printable part; used by the release
  workflow.
- `.github/workflows/`: CI checks and release STL publication.
- `docs/`: mdBook documentation; `docs/illustrations/` renders the images in
  `docs/src/images/` from the model.
- `README.md`: short prose overview; keep details, lists, and figures that
  can go stale in the book.

## OpenSCAD conventions

- Define reusable geometry as modules; only entry-point files should emit
  top-level geometry.
- Use `is_undef(parameter) ? default : parameter` for CLI-overridable values.
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
component for each exported load-bearing STL.

Documentation changes must pass `mdbook build docs`. Re-render affected book
illustrations after geometry changes.

Do not add generated STL, 3MF, PNG, or temporary render artifacts to the
project unless explicitly requested. The rendered book illustrations in
`docs/src/images/` are the exception and are committed.
