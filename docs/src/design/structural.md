# Structural screening

`dynamometer_dimensions.scad` derives the structural checks from the shared
parameters and fails with an assertion when a parameter change makes a
section, clearance, or material limit unsafe. The default structural inputs
are a 50 kg (490 N) platform rating and a 2.0 structural design factor,
giving a 981 N design target. The Crimpdeq itself is rated to 1500 N
(about 150 kg); the printed lugs, not the sensor, limit the platform.

The design factor sets the analytical target; it is not a demonstrated safety
factor, does not establish a safe working load for a printed assembly, and
never permits loading the platform above 50 kg. Never proof-load the installed
sensor to the design target.

## What is screened

All values are at the 981 N design target.

| Check | Stress | Limit |
|---|---|---|
| Eye bearing on each lug (14.5 mm × 4 mm) | 16.9 MPa | 20 MPa, lug bearing |
| Lug root bending across the layers, eye force at the load-cell mid-plane | 6.6 MPa | 12 MPa |
| Lug root shear across the layers | 5.9 MPa | 6 MPa |
| Tongue root at the deck, bending across the layers | 3.1 MPa | 12 MPa |
| Anchor block bearing on its pocket | 1.1 MPa | 12 MPa, bearing |
| Clip on the flat ring under the lug head, largest finger-pull tilt | 10.7 MPa | 12 MPa, bearing |
| Lug neck pulled by the clip, across the layers | 4.5 MPa | 12 MPa |
| Finger lip bending over the full 25 mm edge | 18.4 MPa | 30 MPa, bending |
| Grip side and back walls in tension | 1.3 MPa | 12 MPa |
| Either index key alone, in shear | 10.2 MPa | 12 MPa |
| Key bearing in the rest wing / base slot | 5.6 / 4.4 MPa | 12 MPa, bearing |
| Base slot ligament between positions, in shear | 9.5 MPa | 12 MPa |
| Palm bolster root, across the layers | 1.6 MPa | 12 MPa |
| Rail flanks holding the rest down at its shortest engagement | 4.6 MPa | 6 MPa |

Each index key is screened for the **entire** palm force. Both keys must
still be fitted; the one-key calculation does not authorise using one.
The base joint is in compression under load and is not screened. The
stoppers, grip guides, stopper well and phone stand are outside the load
path.

The clip screen takes the largest finger-pull offset from the load-cell
plane (4 mm, with both stoppers) at the design force. It is reacted between
the clip and the tongue seat, taken 10 mm from the eye centre, and bears on
the outboard half of the flat ring under the lug head only.

## The eye lugs

The lugs replace the steel sleeves and machined collars that a pin bridging
the whole case would need. The case's U-slots let a tongue reach the
underside of each eye, so the lug is a short stub loaded 2 mm above its root
instead of a long pin.

Eye bearing on printed plastic is the governing assumption of the design.
`allowable_lug_bearing_mpa` (20 MPa by default, about 40% of PETG's
compressive yield) is for conformal contact between the metal eye and a
solid, 100%-infill lug. At the platform's 490 N rating the bearing stress is
half the screened value, 8.5 MPa. The anchor block and grip print upright, so
the lug and tongue roots are screened against the cross-layer tension limit,
and lug shear against half of it.

## Limits of the screening

The configured printed-material limits (`allowable_printed_*` and
`allowable_lug_bearing_mpa`) are **assumptions requiring coupon tests**, not
material guarantees. The simplified calculations do not cover the full 3D
stress field, notch factors, one-finger loading, print defects, creep,
fatigue, or temperature effects. Stress concentrations and print orientation
remain unqualified. Digital checks are not FEA, physical proof testing,
calibration, or certification.
