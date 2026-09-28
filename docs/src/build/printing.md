# Printing

## Files

Download the STL files from the latest
[release](https://github.com/crimpdeq/crimpdeq-platform/releases), or export
them into `exports/` from the repository root:

```bash
bash export-parts.sh
```

Use files from a single release or export; parts from different versions may
not fit together.

| File | Contents | Plate |
|---|---|---|
| `crimpdeq-platform-base_front.stl` | Front base half: anchor pocket, grip trench, stopper well, joint tongues | 1 |
| `crimpdeq-platform-grip.stl` | Finger grip with its eye lug, printed on its side | 1 |
| `crimpdeq-platform-anchor.stl` | Anchor block with its eye lug, printed on its side | 1 |
| `crimpdeq-platform-keepers.stl` | Two identical tab keepers | 1 |
| `crimpdeq-platform-keys.stl` | Two identical index keys, printed on their sides | 1 |
| `crimpdeq-platform-stoppers.stl` | Two stackable pocket stoppers, 5 and 10 mm thick | 1 |
| `crimpdeq-platform-base_rear.stl` | Rear base half: rest rail, key slots, joint sockets | 2 |
| `crimpdeq-platform-rest.stl` | Palm rest | 2 |

> [!NOTE]
> The base comes as two halves because it is 271 mm long and does not fit a
> 256 mm bed, even diagonally. The front half is 168 mm long and the rear
> half 116 mm; both are 122 mm wide.

All parts are exported already oriented for printing. Don't rotate them or
use "Lay on face". The anchor block, grip and keys print on their sides on
purpose: the lugs and keys are then loaded along their layers instead of
across them.

## Ready-made Bambu Studio project

Each release also includes `crimpdeq-platform.3mf`, a Bambu Studio project
with both plates already laid out and the [print settings](#print-settings)
applied, including 100% infill for every part except the base halves. It's
set up for a Bambu Lab A1 with a 0.4 mm nozzle, Generic PETG, the textured
PEI plate, and 50% infill for the base halves.

1. Open it with **File → Open Project**.
2. Select your printer, filament and plate. Changing the printer can reset
   process settings, so compare them with the tables below afterwards.
3. Do the [slicer checks](slicer-checks.md) before printing.

## Plate 1: front base half and small parts

![Plate 1 layout](../images/plate1.png)

## Plate 2: rear base half and palm rest

![Plate 2 layout](../images/plate2.png)

Keep the parts at least 15 mm apart.

## Print settings

Use one global process profile, then override per object where listed.

| Setting | Value |
|---|---|
| Layer height | 0.2 mm |
| Walls | 6 |
| Top/bottom layers | 6 |
| Infill | 40–60% for the base halves |
| Supports | On, **Global**, type **tree(auto)**, threshold 30° |
| Brim | Outer brim only, 5 mm |

Per-object override (select the object, switch Process to **Objects**):

| Object | Override |
|---|---|
| `grip`, `anchor`, `keepers`, `keys`, `rest`, `stoppers` | 100% infill |

The lugs must be solid: the load cell's eyes bear on them directly. PETG
prints well on the A1 and is what the structural screens assume, but a
filament name or infill setting does not establish strength. Validate
coupons in the intended print orientation.

## Where supports are needed

| Part | Supported area |
|---|---|
| Grip | Underside of the eye lug, which sticks out sideways about 36–52 mm up |
| Anchor block | Underside of the eye lug, which sticks out sideways about 18–34 mm up |

Nothing else needs support. The base halves print flat with every pocket,
trench, well and slot open upward; the rear half's joint sockets and the
palm rest's rail groove are closed by short bridges. The keepers print flat
on their clamp faces, the keys stand on their sides, and the stoppers print
flat with their pull tabs upright.

Remove the lug supports carefully and sand the round side of each lug
smooth, without flattening it: that is where the load-cell eye bears.
