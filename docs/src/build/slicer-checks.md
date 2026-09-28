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

A floating-regions warning means something is missing support.

## C. Layer 1 (0.20 mm)

- [ ] Every part has a continuous **brim** ring around its outline.
- [ ] The brims of neighbouring parts are separate, or only just touch.
- [ ] The flat faces on the bed are fully filled.
- [ ] On Plate 1, support bases appear beside the grip and the anchor block,
      under their lugs, and nowhere else.
- [ ] Nothing reaches the plate edge or the purge/cutter zone at the back left.

## D. Plate 1: the lugs

Step up until the underside of the grip's lug first appears, then do the
same for the anchor block.

- [ ] Its first layer sits entirely on support interface, with no edge in free
      air.
- [ ] The support doesn't touch the lug's round side above the interface.

## E. Plate 2: bridges

- [ ] At about 20 mm, the roofs of the rear half's two joint sockets are
      straight bridge lines across each socket.
- [ ] At about 6 mm, the roof of the palm rest's rail groove is straight
      bridge lines across the groove.
- [ ] Neither has support inside it.

## F. Infill

- [ ] In the **Line Type** preview, the grip, anchor block, keepers, keys,
      palm rest and stoppers show solid infill all the way through.

## G. Printer and material

- [ ] The textured PEI plate matches the slicer's **Plate type**. Wash it with
      dish soap and warm water, dry it, and don't touch the surface.
- [ ] There's enough dry filament on the spool for the plate, plus margin.
- [ ] There's nothing behind the printer for the moving bed to hit.
- [ ] **Bed leveling** is on in the print dialog.

## H. During the print

- **First 5 minutes:** brims and first layer are flat and stuck down. If a
  corner lifts, stop and clean or re-level.
- **Plate 1, about 18 mm:** the anchor block's lug lands on its support.
- **Plate 1, about 36 mm:** the grip's lug lands on its support.
- **If any part comes loose, stop immediately.** On the A1 a loose tall part
  gets dragged into the others.

The heights above are approximate. Use the layer where each feature first
appears.
