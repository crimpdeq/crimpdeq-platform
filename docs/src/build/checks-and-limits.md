# Checks, feedback and limits

## Assembly checks

- [ ] **Case clearance:** the case touches only the two lugs and seats, never
      the deck, the anchor block, the grip or the keepers.
- [ ] **Keepers:** both are centred and don't slide out when you tap the base.
- [ ] **Grip level:** the grip's top is level. Note whether it hangs free or
      rests on the guide ledges.
- [ ] **All nine positions:** the keys go in and come out easily each time,
      and the rest slides freely between positions.
- [ ] **Case access:** the USB port and switch are reachable.
- [ ] **Base joint:** no visible gap or step between the halves.
- [ ] **Stoppers:** each one, and both stacked, sit flat in the pocket, stay
      put under the fingers, and lift out by their tabs.
- [ ] **Tabletop:** the base stands flat without rocking.

Tare the instrument unloaded before any measurement.

## Comfort checks

Put your fingers in the pocket and the heel of your palm on the palm rest,
without pulling.

- [ ] The finger pocket depth and lip feel natural, with and without each
      stopper.
- [ ] The palm bolster height suits your hand: not too high, not too low.
- [ ] Your thumb stays clear of the key heads.
- [ ] The stopper tabs at the pocket ends don't catch your index or little
      finger.
- [ ] The bolster and deck edges are smooth enough; nothing digs in.
- [ ] Note which openings suit full crimp, half crimp and open hand.

## Feedback form

Copy this table into a comment or a new note.

| Item | Result / notes |
|---|---|
| Printer, material, settings | |
| Parts that needed reprinting | |
| Eye fit on the lugs (tight / good / loose) | |
| Keeper fit (tight / good / loose) | |
| Base joint fit (tight / good / loose) | |
| Key and rail fit (tight / good / loose) | |
| Grip level (level / on the ledges / tilted) | |
| Stopper fit and removal | |
| USB and switch access | |
| Bolster height (lower / good / higher) | |
| Bolster and deck edge comfort | |
| Finger pocket comfort | |
| Best opening for full crimp | |
| Best opening for half crimp | |
| Best opening for open hand | |
| Other issues | |

## Taking it apart

1. Lift out both keys and slide the palm rest off the rear end of the rail.
2. Slide out both keepers and lift the case off the lugs.
3. Lift out the grip and the anchor block.
4. Lift the rear base half off the front half.

## Known limits

> [!WARNING]
> - **Not load-tested.** The printed lugs, the rest of the printed load
>   path and the keys are screened analytically only (see
>   [Structural screening](../design/structural.md)).
> - **Printed eye lugs.** The load-cell eyes bear directly on printed plastic.
>   This is the design's governing assumption and needs coupon and proof
>   tests with the real load cell. Printed parts under sustained load also
>   creep: don't leave the device loaded, and check the lugs for flattening.
> - **Physical validation is still pending:** fit with the real case, comfort,
>   strength of the printed parts, and any load testing.
> - **Grip-guide friction.** If the grip rests on the guide ledges, friction
>   there takes a share of the pull that the load cell doesn't see, roughly
>   the friction coefficient times the force pressing the grip onto them.
>   Keep the ledge tops smooth, and compare readings with the grip resting on
>   them and lifted off them.
> - **Finger-pull offset.** The middle of each edge sits within 4 mm of the
>   load-cell plane, not on it, so the pull tilts the grip slightly. The
>   tilt shows up as ledge contact or as bending of the load cell; compare
>   readings between edges against a reference.
> - **Keepers are friction-fit.** They can't lift or pull away from their
>   walls, but can slide out sideways if knocked.

Loading requires a separately approved, guarded validation setup that never
exceeds the 50 kg load-cell rating. Stop for any unexpected motion or case
contact. Retire printed load-bearing parts after any overload, drop,
cracking, whitening, or permanent deformation, and never apply load unless
both keepers and both keys are fitted.
