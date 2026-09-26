# Validation

Run the complete geometry check after every geometry or dimension change:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

The runner renders every probe in `collision_check.scad`. The probes check
that the frame, grip, wrist rest, case reference, and pin hardware do not
collide at any wrist position, and that intentional contacts are present: the
load-cell eye interfaces, foot contact with the tabletop, and the
finger-pocket floor datum. For the two-piece frame, they check that the halves
rebuild the frame without overlapping, that every lap screw clamps both
halves, that the screws and nuts stay recessed and clear of the moving parts,
and that the wrist rest slides onto the right half from its lap end. They also cover USB and switch access, the finger
entry path, pin withdrawal beside the saddle, hardware clearance to the
tabletop, and the solid, unobstructed palm and heel contact surfaces. The grip
must clear the frame at rest and at rated deflection, and land on both
guide ledges when dropped by the guide gap. Each stopper must fit the pocket,
rest on its floor and be stopped by its walls, and the stack must fit its
storage well. The largest phone must sit in its slot in either orientation,
clear of every other part. Contact
probes use a 0.01 mm intentional overlap to avoid exporting zero-volume mating
faces.

The runner then exports each load-bearing part and uses
`check-stl-components.py` to confirm that each is exactly one connected
component. The stoppers are unloaded separate bodies and are not included. Finally, it confirms that every unsafe parameter override listed in
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

## Continuous integration

`.github/workflows/ci.yml` runs `check-collisions.sh`, runs `check-real-case.sh`
against the `main` branch of crimpdeq-case, and builds this book on every
push to `main` and every pull request.

Digital checks do not validate strength, fit on printed parts, comfort, or
calibration; those still require physical testing.
