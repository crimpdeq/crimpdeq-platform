# Crimpdeq Hand Dynamometer

![Assembled fit prototype](images/overview.png)

The Crimpdeq hand dynamometer is a parametric OpenSCAD platform that turns the
[Crimpdeq](https://github.com/crimpdeq) v2 force sensor into an isometric
finger and hand dynamometer. The closed Crimpdeq enclosure and its
80 × 40 × 4 mm, 50 kg load cell sit in a printed frame. One load-cell eye is
anchored to the frame; the other is pulled by a four-finger hangboard pocket
while the palm pushes against an adjustable wrist rest.

> [!CAUTION]
> This is an **unqualified prototype**, not a certified dynamometer or a
> device for suspending a person. Physical fit, comfort, and guarded load
> validation are still pending. Never load the 50 kg sensor above its rating.

## How this book is organised

[Design](design/index.md) explains the mechanism and the structural
assumptions behind it. [Fit prototype](fit-prototype/index.md) is a
step-by-step guide to printing and assembling an unloaded prototype on a
256 mm printer, so that fit and comfort can be checked. [Loaded
version](loaded-version/index.md) describes the steel hardware, machined
inserts, and printing requirements for a future load-bearing build.
[Development](development/index.md) covers previewing, exporting, and
validating the model.

## Credits

The frame concept, with opposing finger and palm supports on indexed rails,
is inspired by the CC0
[Fingers of Fury hand dynamometer](https://makerworld.com/en/models/3148865-hand-dynamometer).
It is rebuilt natively in OpenSCAD rather than edited from the original model.
The palm bolster shape follows the GoGor LITE pad. The Crimpdeq v2 case and
load cell come from the [Crimpdeq project](https://github.com/crimpdeq).

All illustrations are rendered from the project's OpenSCAD model, so they
match the exported parts.
