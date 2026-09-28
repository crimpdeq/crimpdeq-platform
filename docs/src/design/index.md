# Design

![Section through the load-cell axis](../images/lug_section.png)

The device is isometric and fully printed. The Crimpdeq case lies flat, lid
up, in the middle of a printed base. The load cell's two ends stick out of
the case's side walls, and each end has a Ø17 mm eye that is half outside
the case. Printed lugs sit in the outer halves of those eyes:

- the **anchor block** holds the left eye and bears on the base
- the **finger grip** holds the right eye and carries the hangboard pocket

When the fingers pull the grip toward the palm (+X), the outer rim of each
eye presses on its lug. The force passes from the grip, through the load
cell, into the anchor block, and from there through the base to the palm
rest. It never passes through the case: the case floats 1 mm above the deck
and stays at least 1 mm from every printed part. Its shell, lid and screws
carry no load.

## Eye lugs

Each lug is a D-shaped stub rising 5.5 mm from its seat through the outer
half of an eye. Its round side matches the eye with 0.25 mm clearance. Its
flat side stays 1.2 mm outside the case, so it clears the case's carabiner
tunnels. The eye bears on it across a 16.4 mm chord and the full 4 mm
thickness of the load cell. The top has a 1 mm chamfer so the eye drops on
easily. The load cell's ends rest on flat seats level with the lug roots.

The lugs are part of the anchor block and the grip. Both parts are printed
on their sides, so the lug's bending plane lies in the print layers rather
than across them.

## Tab keepers

Two printed keepers slide across the load-cell ends, beside the eyes, and
clamp them onto their seats. Each keeper has a half-dovetail tongue that runs
in a groove across the end wall of the anchor block or the grip. The tongue's
flat underside is the clamp face. Its sloping top flank stops the keeper from
lifting and from pulling away from the wall; it can move at most 0.3 mm
before the flank catches. The keepers carry no measured load. They hold the
load cell, and with it the grip, level. Sliding them out frees the case.

## Finger pocket

The pocket has an 80 × 20 mm opening and is exactly 25 mm deep. Its walls
have a 1 mm draft and rounded corners, leaving 78 × 18 mm at the floor. A
2 mm radius rolls the loaded +X edge, and the lip keeps at least 8 mm of
material behind it. Fingers enter from +Z and pull toward the palm rest.

The pocket is set low: its top is 11 mm above the load cell's underside and
its floor 14 mm below it. The middle of each edge then sits within 4 mm of
the load-cell plane, from −3.5 mm for the 25 mm edge to +4 mm for the 10 mm
edge. This keeps the finger pull nearly in line with the load cell and
limits the tilt it causes.

## Pocket stoppers

Two drop-in stoppers, 5 and 10 mm thick, raise the pocket floor. On their
own they give 20 and 15 mm edges; stacked, in either order, they give a
10 mm edge. Without a stopper the edge is 25 mm. Each is a 17.5 × 77.5 mm
plate that fits the pocket floor with 0.25 mm clearance, so the pocket walls
locate it. The fingers press it onto the floor or onto the stopper below.

Each stopper has a 3 × 8 mm pull tab on one end face: the 5 mm stopper at one
end, the 10 mm stopper at the other. The tabs run in slots in the pocket end
walls, so the whole top of the stopper stays free for the fingers. With a
stopper on the pocket floor, its tab stands 6 mm above the grip.

When not in use, the stoppers stack in a 16 mm-deep well in the deck, on the
−Y side next to the case.

## Grip guides

The grip hangs from the load cell and does not touch the base. Its trench has
two ledges that run under the grip's side walls, 0.3 mm below them. If the
grip tilts, they catch it and keep its top level, but they leave it free
along X. They only touch the grip once it has dropped onto them, and friction
there then affects readings; see
[Known limits](../build/checks-and-limits.md#known-limits).

## Palm rest and hand positions

The palm rest is one solid part: an upright palm face, a 60 × 78 mm heel deck
level with the top of the finger pocket, and a straight palm bolster along the
finger-facing edge. The bolster is 22 mm deep and rises 20 mm above the
deck, with rolled 6 and 5 mm top edges. Its −X face continues the palm
face. There are no holes, slots or fasteners in the contact area.

The rest slides on a dovetail rail along the middle of the rear base half.
The rail holds it down and sideways, so pushing on the bolster cannot tip it
off. Two printed index keys lock its position. Each key drops through a slot
in one of the rest's side wings, outside the palm area, into one of nine
slots in the deck. The nine positions set the hand opening from 25 to 105 mm
in 10 mm steps. The opening is the clear gap from the outside of the finger
lip to the palm face. Adjustment needs no tools: lift both keys out, slide the
rest, and drop them in again.

Approximate starting points are 25–45 mm for full crimp or smaller hands,
55–75 mm for half crimp, and 85–105 mm for extended fingers or larger hands.
These are setup guides, not ergonomic prescriptions.

## Base

The base is 271 mm long, 122 mm wide and 22.6 mm tall below the deck, so it
is printed as two halves that each fit a 256 mm bed: a 168 mm front half
with the anchor pocket, grip trench and stopper well, and a 116 mm rear half
with the rail and key slots. Two vertical dovetail tongues on the front half
drop into sockets in the rear half. Under load the anchor pushes the front
half toward the rest and the rest pushes the rear half back, so the butt
faces of the joint are in compression. The dovetails only keep the halves
aligned and together when the platform is carried.

The switch and USB port face +Y. Nothing stands above the deck on that side:
a 30 mm-wide corridor in front of both openings stays clear out past the
base edge.
