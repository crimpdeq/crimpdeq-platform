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
- [ ] Support bases appear under the right-half lap tongues, grip-guide
      ledges and channel bridge, the left-half clevis cheek, the wrist-rest deck and the grip
      cheek.
- [ ] The four screw counterbores, the stopper well and the phone slot of
      the left half are open on the bed.
- [ ] Nothing reaches the plate edge or the purge/cutter zone at the back left.

## D. Plate 1: phone slot and stopper well (left half, about 16 mm)

- [ ] At about 16 mm, the first layers closing the phone slot and the stopper
      well are straight bridge lines across each opening.
- [ ] Neither has support inside it.

## E. Plate 1: clevis cheek (left half, about 35–45 mm)

Step up until the clevis cheek with the Ø12.9 mm sleeve hole first appears.

- [ ] Its first layer sits entirely on support interface, with no edge in free
      air, including the outer corner.
- [ ] The support trees don't lean against the rails.

## F. Plate 2: channel bridge, lap tongues and grip guides (right half)

Step up to about 14–18 mm, until the closed end of the right half starts
spanning the channel.

- [ ] The layer just below has dense **support interface** under the bridge.
- [ ] The first bridge layer is straight parallel lines across the gap.

Step up until the two lap tongues at the open end of the right half first
appear.

- [ ] Their first layer sits entirely on support interface, with no edge in
      free air.
- [ ] The support stops at the lap face and doesn't fill the screw holes.
- [ ] At about 31 mm, the two grip-guide ledges on the inner faces of the
      rails also sit entirely on support interface.
- [ ] The support trees stand on the plate, not on the brim.

## G. Plate 3: wrist rest, grip and stoppers

- [ ] The first layer of the heel deck, roughly 35–50 mm up, sits on support
      interface with no free-hanging edge.
- [ ] The first layer of the grip's upper cheek sits on support interface.
- [ ] No support trees grow between the grip and the wrist rest.
- [ ] The top layer of the wrist rest is the palm surface, with no support on it.
- [ ] The stoppers have no support, and their pull tabs print as complete
      upright fins.

## H. Holes and pockets

- [ ] There's no support in the index holes or screw holes.
- [ ] Each screw counterbore of the left half is bridged at about 9 mm.
- [ ] The hex nut pockets at the top of the right half's lap tongues are
      open, with no support or top skin in them.

## I. Top layer

- [ ] On Plates 1 and 2 the last layers are the feet, two on each half.
      They are complete.
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
- **Plate 1, about 16 mm:** the phone slot and stopper well bridges close
  cleanly.
- **Plate 1, about 40 mm:** the clevis cheek lands on its support.
- **Plate 2, about 16 mm:** the channel bridge lands on its support.
- **Plate 2, about 22.5 mm:** the lap tongues land on their support.
- **Plate 2, about 31 mm:** the grip-guide ledges land on their support.
- **If any part comes loose, stop immediately.** On the A1 a loose tall part
  gets dragged into the others.

The heights above are approximate. Use the layer where each feature first
appears.
