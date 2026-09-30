# Slicer checks before printing

The checks take a few minutes per plate in Bambu Studio. Supports only
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

No part needs support, so a floating-regions warning means the parts were
rotated or the model changed. Re-import the release files.

## C. Layer 1 (0.20 mm)

- [ ] Every part has a continuous **brim** ring around its outline.
- [ ] The brims of neighbouring parts are separate, or only just touch.
- [ ] The flat faces on the bed are fully filled.
- [ ] No support appears anywhere; supports are off.
- [ ] Nothing reaches the plate edge or the purge/cutter zone at the back left.

## D. Plate 1: the lugs

- [ ] Step up through the top of the grip's and the anchor block's lugs: the
      neck and head print as closed outlines, and the 1.9 mm ring under each
      head prints as an overhang wall, not in free air.

## E. Plate 2: bridges

- [ ] At about 20 mm, the roofs of the rear half's two joint sockets are
      straight bridge lines across each socket.
- [ ] At about 7 mm, the roof of the palm rest's rail groove is straight
      bridge lines across the groove.

## F. Infill

- [ ] In the **Line Type** preview, the grip, anchor block, clips and keys
      show solid infill all the way through.
- [ ] The palm rest shows 50% sparse infill, and the base halves and
      stoppers 20%.
- [ ] On the rear half, the walls between neighbouring key slots print
      solid, with no sparse infill.

## G. Printer and material

- [ ] The textured PEI plate matches the slicer's **Plate type**. Wash it with
      dish soap and warm water, dry it, and don't touch the surface.
- [ ] There's enough dry filament on the spool for the plate, plus margin.
- [ ] There's nothing behind the printer for the moving bed to hit.
- [ ] **Bed leveling** is on in the print dialog.

## H. During the print

- **First 5 minutes:** brims and first layer are flat and stuck down. If a
  corner lifts, stop and clean or re-level.
- **If any part comes loose, stop immediately.** On the A1 a loose tall part
  gets dragged into the others.

The heights above are approximate. Use the layer where each feature first
appears.
