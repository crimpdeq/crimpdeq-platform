# Requirements

These are the requirements the design must keep. A change to the model that
breaks one is a design change, not a tweak, and this page changes with it.
How the model meets them is a design choice and can change freely. The
structural assertions and collision checks screen many of them; none of them
replaces testing printed parts.

## Load rating

- The Crimpdeq load cell has a 1500 N (about 150 kg) full-scale design load,
  so the printed platform sets the usable limit.
- The platform must be rated for at least 45 kg (about 441 N); a higher
  rating is better.
- The printed structure is sized with a 2.0 structural design factor, but the
  platform is never loaded above its rating.

## Printing

- Prefer 3D-printed parts over bolts, pins, inserts or other purchased
  hardware; add hardware only when it has a clear benefit.
- Every part fits within the 240 mm printable length of a 256 mm bed
  (Bambu Lab A1).

## Case

- The platform holds the crimpdeq-case `v2.0.0` enclosure and every
  earlier release.
- Hand force passes only through the load-cell eyes. The case floats at
  least 1 mm clear of every printed part, and its shell, lid and screws
  never carry load.
- The switch and USB port stay reachable.

## Finger pocket

- The four-finger hangboard pocket is 25 mm deep and at least 80 mm wide.
- The edge depth can be changed to 20, 15 and 10 mm without tools.
- The mid-depth of every edge is within 5 mm of the load-cell plane.

## Palm rest

- The palm rests comfortably at the height of the fingertips on the 20 and
  25 mm edges (Z = −10 mm), so the heel and the fingers pull in line.
- A raised stop gives the palm a face to push against during a pull.
- The rest has seven positively locked positions, for hand openings of 25 to
  85 mm, adjustable without tools.

## Phone stand

- The platform has a phone stand that holds the phone slightly tilted back
  and slightly raised above the table.

## Clearances

- The parts, phone and case are collision-free except at explicitly modelled
  contact surfaces.

## Structural screening

`platform/dimensions.scad` fails with an assertion when a parameter change
takes a load-path part past its stress limit at the design force: the
platform rating times the structural design factor.

The printed-material limits (`allowable_printed_*` and
`allowable_lug_bearing_mpa`) are assumptions that need coupon tests. The
calculations leave out the 3D stress field, notches, one-finger loading,
print defects, creep, fatigue and temperature, and they are not FEA or proof
tests. The design factor is not a demonstrated safety factor and never
permits loading the platform above its rating.
