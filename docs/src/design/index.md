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

The finger pocket has a nominal 80 × 20 mm opening, exactly 25 mm insertion
depth, and drafted walls leaving 78 × 18 mm at the floor (rounded corners).
The depth is the edge the finger pads pull on, like the edge depth of a
hangboard. A 2 mm radius rolls the loaded edge into the top face, widening the
mouth to 22 mm locally without reducing the lip below 8 mm. The left spine
remains full-depth and joins both clevis cheeks. Fingers enter from `+Z` and
pull toward the palm pad. The wide slot and rolled edge are intended to reduce
crowding and edge pressure; comfort still needs testing with different hands.

## Pocket stoppers

Three drop-in stoppers, 5, 10 and 15 mm thick, raise the pocket floor to give
20, 15 and 10 mm edges; without a stopper the edge is 25 mm. Each is a
17.5 × 77.5 mm plate that fills the pocket floor with 0.25 mm clearance, so
the closed pocket walls locate it in both directions and the fingers press it
onto the floor. The loaded lip is unchanged. A Ø3.5 mm pull hole near each
end, outside the 64 mm finger width, takes a knotted cord for lifting the
stopper out; the knot sits in a counterbore underneath.

When not in use, the stoppers stack in a 31 mm-deep well in the left end of
the frame, next to the anchor post.

## Grip guides

The grip hangs from a single joint at the right load-cell eye, and the pocket
sits about 40 mm from it, so the grip and the load cell can tip until the
pocket drops below the frame. Two 38 mm-long ledges on the rail inner faces
reach 4 mm under the grip's side walls, 0.3 mm below them. They catch the
grip if it tips and hold its top level with the frame, but leave it free
along X. They only touch the grip once it has dropped onto them, so friction
there can affect readings; see [Known limits](../build/checks-and-limits.md#known-limits).

## Palm and wrist saddle

The adjustable support is one solid L-shaped saddle, not a series of narrow
contact points. Its 65 × 78 mm heel deck joins the upright palm face with
matching 5 mm rounded edges and no groove at the transition. Two low,
2 mm-high side lips retain 2.4 mm rolled edges. The pad is 10 mm narrower
than the grip so it slides past the grip guides when it goes onto the frame.

At the finger-facing end, a straight palm bolster modelled on the GoGor LITE
pad spans the full 78 mm pad width. It is 22 mm deep and 12 mm tall above
the deck, with a nearly flat 11 mm top, a 6 mm front top radius, a 5 mm rear
top radius, rounded ends blended into the side lips, and a 3 mm concave fillet
into the deck. It has no cup or ridge. The palm heel pushes on its
finger-facing (−X) face, which is one plane with the upright palm face below
it. The bolster starts exactly at that palm-face datum and extends only away
from the fingers, so all nine openings are unchanged. It is rigid printed
material, with no soft layer.

Behind the bolster, a 38 × 68 mm open heel deck remains solid and
uninterrupted: no holes, slots, exposed fasteners, or separate pads beneath
the wrist. The 18 mm-thick deck tops out at Z = 54 mm, 20 mm above the finger
pocket's +Z opening, and the bolster at Z = 66 mm; only the bolster and the
low lips rise above the deck. The deck is 2.5 mm above the pin buttons and
14.5 mm below the bolster top, so a thumb wrapped round the bolster stays
above the pin heads. Its underside is 2 mm above the frame, so it passes over
the solid right post at full travel. The upper pin arms are trimmed flush
with the palm face across the pad width and merge into the deck behind it.

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
join the palm face and the deck. The full-depth indexed rails, the left
load-cell anchor and the right closing post stay intact. The rails sit 10.7 mm
from the case on each side, set by the grip width, so the service tunnel
through the +Y rail is 26 mm long.

Four integral 12 × 12 mm corner feet hold the fixed frame above a flat
tabletop. The modelled bolt nuts and wrist-pin tips keep at least
`support_foot_clearance` to the foot plane; the case shell is not a support.
Set the assembled frame on a level surface and confirm that all four soles
touch without rocking before considering any load.

## Phone slot

An unloaded block outboard of the left anchor post holds the stopper well and,
at the far end, a slot for a phone running the Crimpdeq app. The slot is
14 mm wide, for a phone up to about 13 mm thick in its case, and 16 mm deep
with a flat floor. It leans 15° away from the user, so the screen faces the
hand, and runs across the full frame width, so a phone fits in portrait or
landscape. It is well away from the hand, the grip and the service tunnel,
and it carries no load.

## Two-piece frame

The complete frame is 343.9 mm long and 124 mm wide, so it is printed as two
halves that each fit a 256 mm bed: 210.1 mm and 181.8 mm long. They join at `frame_split_x` with a
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
