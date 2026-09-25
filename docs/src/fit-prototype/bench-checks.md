# Bench-check the printed hardware

Check that the small parts fit each other before assembling anything.

![Printed bolts, nuts, washers, wrist pins and a paperclip retainer](../images/printed_hardware.png)

## Clean up

- Remove supports and brims. Trim any elephant's foot (the flared first layer)
  on the nuts, washers and pegs with a knife.
- Sand support scars on the palm bolster, heel deck and finger pocket smooth.

## Nuts and bolts

1. Screw each nut onto its bolt by hand, all the way to the smooth shank and
   back.
   - The thread is right-handed: clockwise tightens, as with a normal bolt.
2. If it binds, run the nut on and off a few times to clean the thread.
3. If it still binds, re-export a looser set:

   ```bash
   openscad -D render_fn=96 -D 'part="fit_bolt_set"' \
     -D fit_bolt_thread_clearance=0.45 \
     -o exports/crimpdeq-platform-fit_bolt_set.stl dynamometer_assembly.scad
   ```

## Bolts and spacers

- [ ] Each bolt slides through a printed spacer with no force. If not, sand the
      shank lightly.

## Wrist pins

- [ ] Each pin slides through an index hole in the right frame half and a
      wrist-arm hole with no force.
- [ ] A paperclip or 2 mm split pin passes through the cross-hole near the tip.

If the pins are tight, sand them, or re-export with `-D fit_pin_clearance=0.4`
and part `fit_quick_pin_pair`.

## Frame pegs

- [ ] Each peg goes into a frame bore by hand or with light tapping.

There are exactly four pegs, so handle them with care. If they are tight,
sand the pegs, not the bores. If one breaks, re-export `frame_split_pegs` and
print a new set.
