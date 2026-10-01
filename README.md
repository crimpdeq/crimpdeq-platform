# Crimpdeq Platform

![Assembled platform](docs/src/images/overview.png)

A parametric OpenSCAD platform that turns the [Crimpdeq](https://github.com/crimpdeq)
portable force sensor into an isometric finger dynamometer, printed
entirely in plastic with no hardware to buy. The Crimpdeq case
([crimpdeq-case v2.0.0](https://github.com/crimpdeq/crimpdeq-case/tree/v2.0.0)
or earlier)
lies flat on a printed base, and printed lugs rise through the slots in the
case into the two eyes of its load cell: one on a fixed anchor block,
the other on a four-finger hangboard grip that the fingers pull toward the
palm. The case itself floats clear of the base and never carries load.
Drop-in stoppers give 25, 20, 15 and 10 mm edges, the palm rest slides on a
rail and locks with two printed keys into one of seven hand openings, and a
raised stand at the far end holds a phone running the Crimpdeq app clear
of the case.

The project is standalone: it carries its own
simplified reference of the Crimpdeq case interface and does not need the
[crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case) repository to preview,
export, or validate the model.

## Specifications

- **Load rating:** 49 kg (481 N); printed structure sized with a 2.0 design
  factor.
- **Edge depths:** 25, 20, 15 and 10 mm, set with two stackable stoppers (5
  and 10 mm).
- **Finger pocket:** four fingers, 80 mm wide, 2 mm loading-edge radius.
- **Palm rest:** 25–85 mm from the outside of the finger lip to the palm face,
  seven positions in 10 mm steps.
- **Phone slot:** phones up to about 13 mm thick in their case, portrait or
  landscape, leaned back 15°.
- **Size:** 311 × 122 mm base, 60 mm tall at the phone stand.
- **Printing:** no supports and no hardware; the base splits into two halves
  for a 256 mm bed; about 680 g of PETG.
- **Compatibility:** [crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case)
  v2.0.0 and earlier.

## Documentation

The [book](docs/src/SUMMARY.md) covers the design and its structural
assumptions, a step-by-step guide to printing and assembling the parts on a
256 mm printer, and the development workflow. Build it locally with [mdBook](https://rust-lang.github.io/mdBook/):

```bash
mdbook serve docs
```

## Quick start

Ready-to-print STL files and a Bambu Studio project with the plates laid out
are attached to each
[release](https://github.com/crimpdeq/crimpdeq-platform/releases). To preview
the model or export the parts yourself:

```bash
openscad dynamometer_assembly.scad
bash export-parts.sh
```

Validate the geometry after any change to the model:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

## License

This repository is source-available under the
[Crimpdeq Non-Commercial Hardware License](LICENSE). You may study, modify,
and build the design for personal, educational, and research use, and share
modified versions non-commercially. Commercial manufacture or sale of printed
parts, kits, or assembled devices requires prior written permission.
The bundled Inter font in `fonts/` is under its own
[SIL Open Font License](fonts/Inter-LICENSE.txt).
