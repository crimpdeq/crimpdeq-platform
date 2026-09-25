# Structural screening

`dynamometer_dimensions.scad` derives the structural checks from the shared
parameters and fails with an assertion when a parameter change makes a
section, clearance, or material limit unsafe. The default structural inputs
are a 50 kg (490 N) load-cell rating and a 2.0 structural design factor,
giving a 981 N frame design target. The sensor eyes are Ø17 mm, 51 mm apart.

The design factor sets the analytical target; it is not a demonstrated safety
factor, does not establish a safe working load for a printed assembly, and
never permits loading the sensor above 50 kg. Never proof-load the installed
sensor to the frame design target.

## What is screened

At the design target, either wrist locking station is screened for the
**entire** force: pin double shear, arm bearing, and rail bearing. Both pins
must still be locked; the one-station calculation does not authorise
single-pin use. Each steel wrist pin must have at least 1 kN manufacturer-rated
double-shear capacity.

Additional nominal screens cover the left anchor post, unequal clevis
reactions from the sensor's Z offset, the relieved right post, rail net
sections and hole ligaments, the service-tunnel bridge, metal sleeve bending,
collar bearing, finger-lip bending, wrist-arm bending, the upper-arm joint to
the bolster, and local heel-deck bending. The heel-deck screen applies the
full design target at its cantilever tip. It does **not** rate the complete
mechanism for vertical loading or authorise leaning body weight on the wrist
rest.

The long sleeves bridge the enclosure between the cheeks and carry bending,
not just pin shear. Their bending stress and the collar bearing stress both
exceed the printed-material limits, which is why the loaded version requires
[metal inserts](../loaded-version/hardware.md). The M8 bolts retain the joints;
the calculation takes no credit for them reinforcing a loose sleeve.

## Limits of the screening

The configured printed-material limits (`allowable_printed_*` parameters) are
**assumptions requiring coupon tests**, not material guarantees. The
simplified calculations do not cover the full 3D stress field, notch factors,
one-finger loading, print defects, creep, fatigue, or temperature effects.
Stress concentrations and print orientation remain unqualified. Digital checks
are not FEA, physical proof testing, calibration, or certification.
