# Requirements

These are the requirements the design must keep. A change to the model that
breaks one is a design change, not a tweak, and this page changes with it.
The structural assertions and collision checks screen many of them; none of
them replaces testing printed parts.

## Load rating

- The platform is rated for 50 kg (about 490 N). The Crimpdeq itself is rated
  to 1500 N (about 150 kg); the printed lugs set the lower limit.
- The printed structure is sized with a 2.0 structural design factor, but the
  platform is never loaded above its 50 kg rating.

## Printing

- Every part is 3D-printed. There are no bolts, pins, inserts or other
  purchased hardware.
- Every part prints without supports.
- Each base half fits within the 240 mm printable length of a 256 mm bed
  (Bambu Lab A1). The halves join with vertical dovetails whose joint faces
  are in compression under load.

## Case and load path

- The platform holds the crimpdeq-case `v2.0.0` enclosure.
- The case lies flat, lid up, and floats at least 1 mm above the deck and
  clear of every printed part. Its shell, lid and screws never carry load.
- Hand force passes through printed round lugs in both Ø17 mm load-cell
  eyes: the anchor block's lug and the grip's lug. Each stands on a tongue
  rising through the case's eye U-slot, at least 1 mm from the case and its
  lid battery walls.
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
- The mid-depth of every edge is within 5 mm of the load-cell plane.
- Two stackable drop-in stoppers, 5 and 10 mm thick, give 20, 15 and 10 mm
  edges. The closed pocket walls locate them.
- Their pull tabs run in slots in the pocket end walls and stand proud of the
  grip top, leaving the whole top of each stopper free for the fingers.
- The stoppers are stored in a well in the deck beside the case.
- Grip-guide ledges run under the grip's side walls with a 0.8–1.2 mm Z gap
  and free X travel, so they catch tilt without carrying measured load.

## Palm rest

- The solid heel deck is level with the pocket mouth. The palm bolster rises
  18–24 mm above it and at least 2 mm above the key heads.
- The rest has nine positively locked positions, for hand openings of 25 to
  105 mm.
- The rest is captured on a dovetail rail and locked by two printed index
  keys in deck slots outside the palm area. Adjustment needs no tools.
- Either index key alone is screened for the entire design force, and both
  travel extremes are checked after every geometry change.

## Phone stand

- A tilted phone slot runs across a two-cheek stand at the far (−X) end of
  the base. A narrow phone rests on both cheeks.
- The slot floor is at Z = 15 mm, so the case hides the phone only from
  viewpoints less than 20° above the table.
- The stand leaves finger room by the stopper well, is outside the load path,
  and is clear of the hand at every rest position.

## Clearances

- The base, anchor block, grip, clips, rest, keys, phone and case are
  collision-free except at explicitly modelled contact surfaces.
