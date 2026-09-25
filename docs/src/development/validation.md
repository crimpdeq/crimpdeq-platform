# Validation

Run the complete geometry check after every geometry or dimension change:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

The runner renders every probe in `collision_check.scad`. The probes check
that the frame, grip, wrist rest, case reference, and pin hardware do not
collide at any wrist position, and that intentional contacts are present: the
load-cell eye interfaces, foot and brace contact with the tabletop, and the
finger-pocket floor datum. They also cover USB and switch access, the finger
entry path, pin withdrawal beside the saddle, hardware clearance to the
tabletop, and the solid, unobstructed palm and heel contact surfaces. Contact
probes use a 0.01 mm intentional overlap to avoid exporting zero-volume mating
faces.

The runner then exports each load-bearing part and uses
`check-stl-components.py` to confirm that each is exactly one connected
component. Finally, it confirms that every unsafe parameter override listed in
the script is rejected by an assertion. OpenSCAD errors and warnings fail the
run, even when the resulting intersection is empty.

## Checking against the real case

`check-real-case.sh` is an optional integration check against the actual
[crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case) source instead of
the local reference. It covers the frame, moving grip, eye hardware fit
envelopes, and every wrist index. It expects the case repository next to this
one, or at the path in `CRIMPDEQ_CASE_DIR`:

```bash
CRIMPDEQ_CASE_DIR=../crimpdeq-case/case bash check-real-case.sh
```

Digital checks do not validate strength, fit on printed parts, comfort, or
calibration; those still require physical testing.
