# Slicer checks before printing

The checks take about 5 minutes per plate in Bambu Studio. Supports only
appear after slicing, so do them in **Preview**, not in Prepare.

## A. Set up the Preview view

1. Click **Slice plate**, then open **Preview**.
2. In the **Slicing Result** panel, set **Color Scheme** to **Line Type**.
   Brim, support, support interface and walls then get separate colours.
3. Click the vertical layer slider on the right once. **↑/↓** step one layer
   and **Shift+↑/↓** jump five.
4. Press **1** for top view and **0** for iso view. Right-drag pans; scroll zooms.

## B. Slicer warnings

- [ ] The bottom-right notification area shows no yellow or red warnings, such
  as *floating regions*, *empty layers* or *object outside plate*.

A floating-regions warning means something is missing support.

## C. Layer 1 (0.20 mm)

- [ ] Every tall part has a continuous **brim** ring around its outline.
- [ ] There's no brim inside the frame U openings, as expected with "Outer brim only".
- [ ] The brims of neighbouring parts are separate, or only just touch.
- [ ] The flat faces on the bed are fully filled.
- [ ] Support bases appear under the right-half lap tongues and channel
      bridge, the left-half clevis cheek, the wrist-rest deck and the grip
      cheek.
- [ ] The four screw counterbores of the left half are open on the bed.
- [ ] Nothing reaches the plate edge or the purge/cutter zone at the back left.

## D. Plate 1: channel bridge (right half, about 14–18 mm)

Step up until the closed end of the right half starts spanning the channel.

- [ ] The layer just below has dense **support interface** under the bridge.
- [ ] The first bridge layer is straight parallel lines across the gap.
- [ ] The support trees stand on the plate, not on the brim or the other half.

## E. Plate 1: lap tongues (right half, about 22.5 mm)

Step up until the two lap tongues at the open end of the right half first
appear.

- [ ] Their first layer sits entirely on support interface, with no edge in
      free air.
- [ ] The support stops at the lap face and doesn't fill the screw holes.

## F. Plate 1: clevis cheek (left half, about 35–45 mm)

Step up until the cheek with the Ø17 hole first appears.

- [ ] Its first layer sits entirely on support interface, with no edge in free
      air, including the outer corner.
- [ ] The support trees don't lean against the other half.

## G. Plate 2: wrist rest and grip

- [ ] The first layer of the heel deck, roughly 35–50 mm up, sits on support
      interface with no free-hanging edge.
- [ ] The first layer of the grip's upper cheek sits on support interface.
- [ ] No support trees grow between the grip and the wrist rest.
- [ ] The top layer of the wrist rest is the palm surface, with no support on it.

## H. Holes and pockets

- [ ] There's no support in the index holes or screw holes.
- [ ] Each screw counterbore of the left half is bridged at about 5.5 mm.
- [ ] The hex nut pockets at the top of the right half's lap tongues are
      open, with no support or top skin in them.

## I. Top layer

- [ ] On Plate 1 the last layers are the feet, two on each half. They are
      complete.
- [ ] No stray support sticks up above any part.

## J. Printer and material

- [ ] The textured PEI plate matches the slicer's **Plate type**. Wash it with
      dish soap and warm water, dry it, and don't touch the surface.
- [ ] There's enough dry filament on the spool for the plate, plus margin.
- [ ] There's nothing behind the printer for the moving bed to hit.
- [ ] **Bed leveling** is on in the print dialog.

## K. During the print

- **First 5 minutes:** brims and first layer are flat and stuck down. If a
  corner lifts, stop and clean or re-level.
- **Plate 1, about 16 mm:** the channel bridge lands on its support.
- **Plate 1, about 22.5 mm:** the right half's lap tongues land on their
  support.
- **Plate 1, about 40 mm:** the clevis cheek lands on its support.
- **If any part comes loose, stop immediately.** On the A1 a loose tall part
  gets dragged into the others.

The heights above are approximate. Use the layer where each feature first
appears.
