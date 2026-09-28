# Crimpdeq Platform

![Assembled platform](docs/src/images/overview.png)

A parametric OpenSCAD platform that turns the [Crimpdeq](https://github.com/crimpdeq)
portable force sensor into an isometric finger dynamometer, printed
entirely in plastic with no hardware to buy. The Crimpdeq case lies flat on
a printed base, and printed lugs drop into the two eyes of its 50 kg load
cell: one on a fixed anchor block, the other on a four-finger hangboard grip
that the fingers pull toward the palm. The case itself floats clear of the
base and never carries load. Drop-in stoppers give 25, 20, 15 and 10 mm
edges, and the palm rest slides on a rail and locks with two printed keys
into one of nine hand openings.

The project is standalone: it carries its own
simplified reference of the Crimpdeq case interface and does not need the
[crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case) repository to preview,
export, or validate the model.

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
