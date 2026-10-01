# Validation

Run the complete geometry check after every geometry or dimension change:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

The runner renders every probe in `collision_check.scad`. The probes check
that the base halves, anchor block, grip, clips, palm rest, keys and case
reference don't collide, with the grip also at rated deflection and the rest
at each of its seven positions. The case must clear the base even lowered by
nearly its 1 mm float gap, and must lower onto both lugs from above without
touching them. They check that intentional contacts are present: the load
cell rests on both tongues, each eye bears on its lug when the grip is
pulled, each clip presses on the load cell, the anchor block sits on its
pocket floor and bears on the pocket's +X wall, the grip lands on both guide
ledges when dropped by the guide gap, and the base halves bear on their joint
faces. Each clip must drop into its U-slot beside the lug and slide in
touching only the neck it snaps round, and once fitted must catch the lug head
when lifted and the neck when pulled out. Dovetail probes check that the palm
rest and the base halves are caught once they move by their flank clearance,
and that both keys catch their slots in X at each end of the travel. The palm
rest must slide onto the rail from the rear end, and the USB and switch
corridor and the finger entry path must stay clear. Each stopper, and both
stacked in either order, must fit the pocket and be stopped by its walls,
with its pull tab standing above the grip and nothing above its plate, and
the stack must fit its storage well. The largest phone must sit in its slot
in either orientation, clear of every other part. Contact probes back mating
faces off by 0.01 mm, or push them 0.02 mm together, to avoid exporting
zero-volume faces.

The runner then exports every part and uses `check-stl-components.py` to
confirm that the base halves, anchor block, grip and palm rest are each
exactly one connected component, and the clips, keys and stoppers exactly
two. Finally, it confirms that every unsafe parameter override listed in the
script is rejected by an assertion. OpenSCAD errors and warnings fail the
run, even when the resulting intersection is empty.

## Checking against the real case

`check-real-case.sh` is an optional integration check against the actual
[crimpdeq-case v2.0.0](https://github.com/crimpdeq/crimpdeq-case/tree/v2.0.0)
source instead of the local reference. It covers the base, anchor block, grip
(also at rated deflection), clips, stored stoppers, phone, the case being
lowered onto the lugs, both clips' fitting paths, and the palm rest and keys
at every position. It expects the case repository next to this one, checked
out at `v2.0.0`, or the path in `CRIMPDEQ_CASE_DIR`:

```bash
git -C ../crimpdeq-case switch --detach v2.0.0
CRIMPDEQ_CASE_DIR=../crimpdeq-case/case bash check-real-case.sh
```

Earlier crimpdeq-case releases also pass. `v0.1.0` and `v0.2.0` name their
sources `enclosure_main.scad` and `enclosure_lid.scad` instead of
`case_main.scad` and `case_lid.scad`, so the script cannot read them as-is.

## Continuous integration

`.github/workflows/ci.yml` runs `check-collisions.sh`, runs `check-real-case.sh`
against crimpdeq-case `v2.0.0`, and builds this book on every
push to `main` and every pull request. These checks and the release export
use the OpenSCAD development snapshot pinned in
`.github/actions/setup-openscad/action.yml`. Its Manifold backend runs the
collision checks in seconds rather than the quarter of an hour the CGAL-only
2021.01 release needs, so `.github/workflows/compat.yml` checks 2021.01
weekly instead of on every change. Bump the pin deliberately, after the
checks pass locally on the new snapshot, and run a release dry run (see
[Previewing and exporting](exporting.md)) before the next release. Do the
same when bumping the pinned Bambu Studio version.

Digital checks do not validate strength, fit on printed parts, comfort, or
calibration; those still require physical testing.
