# Design

The device is isometric. The fixed frame anchors the left load-cell eye, and
a recessed four-finger hangboard pocket pulls the right eye. The palm bears
against a continuous rounded face beside the finger pocket, and the wrist heel
rests on an integral, unperforated deck extending away from the fingers. The
hand does not rest on the adjustment rails or their gaps.

Hand force is routed through both Ø17 mm load-cell eyes, pin sleeves, collars,
and double-shear clevis cheeks. The enclosure shell, lid, and M2.5 enclosure
screws are not in the force path. The switch and USB port stay reachable
through a service tunnel in the +Y frame rail.

Nine positively locked positions set a 25–105 mm hand opening in 10 mm steps.
Two tethered Ø6 mm push-button ball-lock pins pass through discrete holes in
the fixed rails and round holes in the wrist rest's short, stiff arms.
Adjustment needs no tools.

## Finger pocket

The finger pocket has a nominal 66.6 × 20 mm opening, exactly 20 mm insertion
depth, and drafted walls leaving 64.6 × 18 mm at the floor (rounded corners).
A 2 mm radius rolls the loaded edge into the top face, widening the mouth to
22 mm locally without reducing the lip below 8 mm. The left spine remains
full-depth and joins both clevis cheeks. Fingers enter from `+Z` and pull
toward the palm pad. The wider slot and rolled edge are intended to reduce
crowding and edge pressure; comfort still needs testing with different hands.

## Palm and wrist saddle

The adjustable support is one solid L-shaped saddle, not a series of narrow
contact points. Its 65 × 74.6 mm heel deck joins the upright palm face with
matching 5 mm rounded edges and no groove at the transition. Two low,
2 mm-high side lips retain 2.4 mm rolled edges.

At the finger-facing end, a straight palm bolster modelled on the GoGor LITE
pad spans the full 74.6 mm pad width. It is 22 mm deep and 12 mm tall above
the deck, with a nearly flat 11 mm top, a 6 mm front top radius, a 5 mm rear
top radius, rounded ends blended into the side lips, and a 3 mm concave fillet
into the deck. It has no cup or ridge. The palm heel pushes on its
finger-facing (−X) face, which is one plane with the upright palm face below
it. The bolster starts exactly at that palm-face datum and extends only away
from the fingers, so all nine openings are unchanged. It is rigid printed
material, with no soft layer.

Behind the bolster, a 38 × 64.6 mm open heel deck remains solid and
uninterrupted: no holes, slots, exposed fasteners, or separate pads beneath
the wrist. The 14 mm-thick deck sits at Z = 34 mm, level with the finger
pocket's +Z opening; only the bolster and the low lips rise above it. A
rounded clearance channel in the fixed right post keeps 2 mm under the deck at
full wrist travel. The upper pin arms are trimmed flush with the palm face
across the pad width and join the saddle through the bolster's end faces.

The whole saddle moves with the selected opening. The index holes and release
pins remain outboard of the contact surface; they are adjustment features, not
places to position the hand. The raised deck can overhang the right end of the
frame at wider settings. Keep that overhang free rather than propping it on a
table, keep skin clear of the moving rail and arm gaps, and adjust only when
unloaded. Smooth any print seam before use.

The openings are measured as the clear X gap from the **outside of the loading
lip** to the palm-pad face, not from the recessed finger-contact surface.
Approximate starting points are 25–45 mm for full crimp or smaller hands,
55–75 mm for half crimp, and 85–105 mm for extended fingers or larger hands.
These are setup guides, not ergonomic prescriptions.

## Frame and feet

The lower wrist arms are 28 mm wide. The upper arms extend 3 mm farther away
from the fingers, giving 24 mm of joint length behind the palm face where they
enter the bolster's end faces. The full-depth indexed rails and left load-cell
anchor stay intact; the right closing post retains a 29 mm-deep lower bridge
and 15 mm side webs under its clearance channel.

Four integral 12 × 12 mm corner feet hold the fixed frame above a flat
tabletop. The modelled bolt nuts and wrist-pin tips keep at least
`support_foot_clearance` to the foot plane; the case shell is not a support.
Set the assembled frame on a level surface and confirm that all four soles
touch without rocking before considering any load.

## Two-piece frame

The complete frame is 297.6 mm long, so it is printed as two halves that fit a
256 mm bed: 163.8 mm and 181.8 mm long. They join at `frame_split_x` with a
48 mm half-lap in each side rail, crossing only plain rail clear of the
service tunnel, load anchor, feet and index holes, and clear of the wrist arms
at minimum travel. The left half keeps the upper half of the rail depth and
the right half the lower half.

Two M5 × 35 socket-head screws per rail clamp the lap. Their heads sit in
counterbores in the top face and nyloc nuts in hex pockets in the bottom face,
so nothing stands proud of the frame. Rail compression bears on the lap
shoulders; the screws and the thinner tongue are also screened for the full
design force (see [Structural screening](structural.md)). Because the frame
only closes when the halves are bolted, the wrist rest can slide onto the
right half first and be removed again later.
