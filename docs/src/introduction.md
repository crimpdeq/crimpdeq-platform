# Crimpdeq Platform

![Assembled platform](images/overview.png)

Crimpdeq Platform is a parametric OpenSCAD design that turns the
[Crimpdeq](https://github.com/crimpdeq) force sensor into an isometric finger
dynamometer. The Crimpdeq case (crimpdeq-case v2.0.0 or earlier) lies flat
on a printed base, 1 mm above the deck. Printed lugs rise through the slots in
the case into the two eyes of its 80 × 40 × 4 mm load cell: one on a
fixed anchor block, one on a four-finger hangboard grip. The fingers pull the
grip toward the palm, which pushes on an adjustable palm rest. A raised stand
at the far end holds a phone running the Crimpdeq app, raised clear of the case.

Every part is 3D-printed. There are no bolts, pins, inserts or other
hardware to buy.

## How this book is organised

[Design](design/index.md) explains the mechanism and the structural
assumptions behind it. [Build](build/index.md) explains how to print the parts and
assemble them.
[Development](development/index.md) covers previewing, exporting, and
validating the model.

All illustrations are rendered from the project's OpenSCAD model, so they
match the exported parts.
