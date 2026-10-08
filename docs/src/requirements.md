# Requirements

These are the requirements the design must keep. A change to the model that
breaks one is a design change, not a tweak, and this page changes with it.
The structural assertions and collision checks screen many of them; none of
them replaces testing printed parts.

## Load rating

- The platform is rated for 49 kg (about 481 N). The Crimpdeq itself is rated
  to 1500 N (about 150 kg); the printed lugs set the lower limit.
- The printed structure is sized with a 2.0 structural design factor, but the
  platform is never loaded above its 49 kg rating.

## Printing

- Every part is 3D-printed. There are no bolts, pins, inserts or other
  purchased hardware.
- Every part prints without supports.
- Each base half fits within the 240 mm printable length of a 256 mm bed
  (Bambu Lab A1). The halves join with vertical dovetails whose joint faces
  are in compression under load.

## Case and load path

- The platform holds the crimpdeq-case `v2.0.0` enclosure and every
  earlier release.
- The case lies flat, lid up, and floats at least 1 mm above the deck and
  clear of every printed part. Its shell, lid and screws never carry load.
- Hand force passes through printed round lugs in the Ø15 mm ring bores
  of both load-cell eyes: the anchor block's lug and the grip's lug. Each
  stands on a tongue rising through the case's eye U-slot, at least 1 mm
  from the case and its lid battery walls.
- The lugs are solid. The anchor block and grip print upright, so the lug and
  tongue roots are screened across the layers.
- Two snap-on eye clips hold the load cell down under the lug heads. Each
  fits by dropping into its U-slot and sliding onto the lug neck, with finger
  room beside the grip-side fin.
- The clips carry the grip's tilt but not the pull; the clip ring and lug
  neck are screened for that tilt.
- The switch and USB port stay reachable from the open +Y side of the base.

## Finger pocket and stoppers

- The four-finger hangboard pocket is exactly 25 mm deep, with an opening at
  least 80 mm wide, a 6 mm back wall and an 8 mm loading lip. Its +Z opening
  stays clear.
- The mid-depth of every edge is within 5 mm of the load-cell plane. The
  current model is at most 4 mm off, on the 10 mm edge.
- Two stackable drop-in stoppers, 5 and 10 mm thick, give 20, 15 and 10 mm
  edges. The closed pocket walls locate them.
- Their pull tabs run in slots in the pocket end walls and stand proud of the
  grip top, leaving the whole top of each stopper free for the fingers.
- The stoppers are stored in a well in the deck beside the case.
- Grip-guide ledges run under the grip's side walls with a 0.8–1.2 mm Z gap
  and free X travel, so they catch tilt without carrying measured load.

## Palm rest

- The heel deck (the rest's plate and the rear deck beside it) lies between
  the fingertips on the 20 and 25 mm edges (Z = −10 mm), so the heel and the
  fingers pull in line. The palm bolster rises 10–14 mm above it.
- Nothing but the bolster stands above the heel deck around the hand.
- The rest has seven positively locked positions, for hand openings of 25 to
  85 mm.
- The rest slides in a dovetail channel sunk into the rear base half, which
  carries the whole heel plate at every position. One printed index key,
  pushed in under the deck across the full width of the base, locks it.
  Adjustment needs no tools.
- The index key is screened for the entire design force, and both travel
  extremes are checked after every geometry change.

## Phone stand

- A tilted phone slot runs across a two-cheek stand at the far (−X) end of
  the base. A narrow phone rests on both cheeks.
- The slot floor is at Z = 15 mm, so the case hides the phone only from
  viewpoints less than 20° above the table.
- The stand leaves finger room by the stopper well, is outside the load path,
  and is clear of the hand at every rest position.

## Clearances

- The base, anchor block, grip, clips, rest, key, phone and case are
  collision-free except at explicitly modelled contact surfaces.

## Structural screening

`platform/dimensions.scad` fails with an assertion when a parameter change
takes any of these checks past its limit. Values are at the 961 N design
target: the 481 N rating times the 2.0 design factor.

| Check | Stress | Limit |
|---|---|---|
| Eye bearing on each lug (14.3 mm × 4 mm) | 16.8 MPa | 20 MPa, lug bearing |
| Lug root bending across the layers, eye force at the load-cell mid-plane | 6.7 MPa | 12 MPa |
| Lug root shear across the layers | 5.98 MPa | 6 MPa |
| Tongue root at the deck, bending across the layers | 3.1 MPa | 12 MPa |
| Anchor block bearing on its pocket | 1.1 MPa | 12 MPa, bearing |
| Clip on the flat ring under the lug head, largest finger-pull tilt | 11.1 MPa | 12 MPa, bearing |
| Lug neck pulled by the clip, across the layers | 4.4 MPa | 12 MPa |
| Finger lip bending over the full 25 mm edge | 18.0 MPa | 30 MPa, bending |
| Grip side and back walls in tension | 1.2 MPa | 12 MPa |
| Index key, in shear at the channel floor | 2.1 MPa | 12 MPa |
| Key bearing in the rest's groove / the floor groove | 5.1 / 3.6 MPa | 12 MPa, bearing |
| Rib between neighbouring floor grooves, in shear | 3.4 MPa | 12 MPa |
| Palm bolster root, across the layers | 1.1 MPa | 12 MPa |
| Channel lips holding the rest down | 0.8 MPa | 6 MPa |

The clip check takes the 10 mm edge's 4 mm offset, reacted between the clip
and the tongue seat 10 mm from the eye centre. The base joint is in
compression and is not screened; the stoppers, grip guides, stopper well and
phone stand are outside the load path.

The printed-material limits (`allowable_printed_*` and
`allowable_lug_bearing_mpa`) are assumptions that need coupon tests. The
calculations leave out the 3D stress field, notches, one-finger loading,
print defects, creep, fatigue and temperature, and they are not FEA or proof
tests. The design factor is not a demonstrated safety factor and never
permits loading the platform above 49 kg.
