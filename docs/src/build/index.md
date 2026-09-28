# Build

![Assembled platform](../images/overview.png)

This part of the book explains how to print and assemble the Crimpdeq finger
dynamometer on a Bambu Lab A1, or any printer with a 256 mm bed. Every part
is printed; there is nothing to buy apart from filament.

> [!CAUTION]
> **The design has not been load-tested.** Physical validation of the fit and
> of the printed load path, especially the lugs in the load-cell eyes, is
> still pending. Do not pull on the device outside a separately approved,
> guarded validation setup, and never load the sensor above its 50 kg rating.

## What you are building

The Crimpdeq case, from
[crimpdeq-case v2.0.0](https://github.com/crimpdeq/crimpdeq-case/tree/v2.0.0),
lies on the **base** (grey), printed as a front and a rear half. Lugs rise
through the slots at both ends of the case into its load-cell eyes:

- the left eye drops onto the lug of the **anchor block** (red), which sits
  in a pocket in the base
- the right eye drops onto the lug of the **finger grip** (blue), which has a
  25 mm-deep hangboard pocket and hangs in a trench in the base

Two **eye clips** (yellow) snap round the lugs and hold the load cell down.
The **palm rest** (orange) slides on a rail on the rear half and is locked in
one of nine positions by two **index keys** (green). Two **pocket stoppers**
(teal) drop into the pocket, alone or stacked, for 20, 15 and 10 mm edges,
and are stored in a well beside the case. A tilted slot at the far end holds
a phone running the Crimpdeq app. The USB port and switch face the open side
of the base.

## Colour key

The illustrations use the same colours throughout.

![Colour key](../images/legend.png)

## Overall workflow

1. [Print](printing.md) both plates, after the
   [slicer checks](slicer-checks.md).
2. [Check the parts](check-the-parts.md) against each other and the case.
3. Join the base halves and fit the [anchor block](base-and-anchor.md).
4. Fit the [grip, case and clips](grip-case-and-clips.md).
5. Fit the [palm rest](palm-rest-and-positions.md) and try every hand
   position.
6. Fit the [stoppers and phone](stoppers-and-phone.md).
7. Run the [final checks](checks-and-limits.md) and record your feedback.
