# Agent Instructions

## Project scope

- This is a standalone OpenSCAD project; do not add runtime dependencies on
  [crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case);
  `check-real-case.sh` is the only optional integration check against it.
- `crimpdeq_reference.scad` is a local fit/collision reference of
  crimpdeq-case `v2.0.0`, not a replacement enclosure design; run
  `check-real-case.sh` against that tag.
- Keep all dimensions in millimetres and forces in newtons.

## Design invariants

- The load cell is rated for 50 kg (approximately 490 N).
- The printed structure is sized with a 2.0 structural safety factor, but the
  sensor must never be tested above its 50 kg rating.
- Keep every part 3D-printed; do not add bolts, pins, inserts or other
  purchased hardware.
- The Crimpdeq case lies flat, lid up, and floats at least 1 mm above the
  deck and clear of every printed part; its shell, lid and screws are never
  load-bearing members.
- Route hand force through the printed round lugs in both Ø17 mm load-cell
  eyes: the anchor block's lug and the grip's lug, each on a tongue rising
  through the case's eye U-slot at least 1 mm from the case and its lid
  battery walls. Keep the lugs solid, and screen the lug and tongue roots
  across the layers (anchor block and grip printed upright).
- Keep both snap-on eye clips holding the load cell down under the lug heads,
  fitted by dropping into the U-slot and sliding onto the neck, and outside
  the load path.
- Keep the four-finger hangboard pocket exactly 25 mm deep with at least an
  80 mm-wide opening, 6 mm back wall, and 8 mm loading lip, its `+Z` opening
  clear, and every edge's mid-depth within 5 mm of the load-cell plane.
- Keep the two stackable drop-in pocket stoppers (5 and 10 mm) for 20, 15,
  and 10 mm edges located by the closed pocket walls, with pull tabs in
  slots in the pocket end walls that stand proud of the grip top and leave
  the whole stopper top free for the fingers, and their storage well in the
  deck beside the case.
- Keep the grip-guide ledges under the grip's side walls with a Z gap and
  free X travel, so they catch tilt without carrying measured load.
- Keep the palm rest's solid heel deck level with the pocket mouth and its
  palm bolster rising 18–24 mm above it, at least 2 mm above the key heads.
- Preserve its nine positively locked 25–105 mm opening positions, with the
  rest captured on a dovetail rail and locked by two printed index keys in
  deck slots outside the palm area; adjustment must remain tool-free.
- Screen either index key for the entire design force, and verify both
  travel extremes after geometry changes.
- Keep each base half within the 240 mm printable length of a 256 mm bed
  (Bambu Lab A1), joined by vertical dovetails with the joint faces in
  compression under load.
- Preserve switch and USB access on the open +Y side of the base.
- Keep the tilted phone slot across the far (-X) end of the base, outside the
  load path and clear of the hand at every rest position.
- Keep every part printable without supports.
- Keep the base, anchor, grip, clips, rest, keys, phone and case collision-free
  except for explicitly modelled contact surfaces.

## File responsibilities

- `dynamometer_dimensions.scad`: shared parameters, derived dimensions, and
  structural assertions.
- `dynamometer_parts.scad`: printable base, anchor, grip, clip, rest, key
  and stopper modules, and the phone slot, without top-level geometry.
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
- `.github/workflows/`: CI checks, release STL publication, and a weekly
  OpenSCAD 2021.01 compatibility check.
- `.github/actions/setup-openscad/`: the pinned OpenSCAD snapshot used by CI
  and releases.
- `.github/actions/setup-bambu-studio/`: the pinned Bambu Studio used to
  build the release project.
- `docs/`: mdBook documentation; `docs/illustrations/` renders the images in
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
