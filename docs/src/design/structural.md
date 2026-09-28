# Structural screening

`dynamometer_dimensions.scad` derives the structural checks from the shared
parameters and fails with an assertion when a parameter change makes a
section, clearance, or material limit unsafe. The default structural inputs
are a 50 kg (490 N) load-cell rating and a 2.0 structural design factor,
giving a 981 N design target.

The design factor sets the analytical target; it is not a demonstrated safety
factor, does not establish a safe working load for a printed assembly, and
never permits loading the sensor above 50 kg. Never proof-load the installed
sensor to the design target.

## What is screened

All values are at the 981 N design target.

| Check | Stress | Limit |
|---|---|---|
| Eye bearing on each lug (16.4 mm chord × 4 mm) | 14.9 MPa | 20 MPa, lug bearing |
| Lug root bending, eye force at the load-cell mid-plane | 24.0 MPa | 30 MPa, bending |
| Lug root shear | 10.6 MPa | 12 MPa |
| Anchor block bearing on its pocket | 1.1 MPa | 12 MPa, bearing |
| Finger lip bending over the full 25 mm edge | 28.7 MPa | 30 MPa, bending |
| Grip side and back walls in tension | 1.3 MPa | 12 MPa |
| Either index key alone, in shear | 10.2 MPa | 12 MPa |
| Key bearing in the rest wing / base slot | 5.9 / 4.4 MPa | 12 MPa, bearing |
| Base slot ligament between positions, in shear | 9.5 MPa | 12 MPa |
| Palm bolster root, across the layers | 1.6 MPa | 12 MPa |
| Rail flanks holding the rest down at its shortest engagement | 4.5 MPa | 6 MPa |

Each index key is screened for the **entire** palm force. Both keys must
still be fitted; the one-key calculation does not authorise using one.
The base joint is in compression under load and is not screened. The
keepers, stoppers, grip guides and stopper well are outside the load path.

## The eye lugs

The lugs replace the steel sleeves and machined collars that a pinned joint
through the whole case would need. They only work because the compact case
leaves the outer half of each eye exposed: the lug is a short stub, loaded
2 mm above its root, instead of a long pin bridging the case.

Eye bearing on printed plastic is the governing assumption of the design.
`allowable_lug_bearing_mpa` (20 MPa by default, about 40% of PETG's
compressive yield) is for conformal contact between the metal eye and a
solid, 100%-infill lug. At the sensor's 490 N rating the bearing stress is
half the screened value, 7.5 MPa. Lug bending and shear rely on the anchor
block and grip being printed on their sides, so that the lug's bending plane
lies in the layers.

## Limits of the screening

The configured printed-material limits (`allowable_printed_*` and
`allowable_lug_bearing_mpa`) are **assumptions requiring coupon tests**, not
material guarantees. The simplified calculations do not cover the full 3D
stress field, notch factors, one-finger loading, print defects, creep,
fatigue, or temperature effects. Stress concentrations and print orientation
remain unqualified. Digital checks are not FEA, physical proof testing,
calibration, or certification.
