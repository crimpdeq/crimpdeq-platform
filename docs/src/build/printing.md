# Printing

## Files

Download the STL files from the latest
[release](https://github.com/crimpdeq/crimpdeq-platform/releases), or export
them into `exports/` from the repository root (this takes a few minutes):

```bash
bash export-parts.sh
```

Use files from a single release or export; parts from different versions may
not fit together.

| File | Contents | Plate |
|---|---|---|
| `crimpdeq-platform-frame_left.stl` | Left frame half (fixed clevis, USB window, upper lap tongues) | 1 |
| `crimpdeq-platform-frame_right.stl` | Right frame half (index holes, palm post, lower lap tongues) | 1 |
| `crimpdeq-platform-wrist_rest.stl` | Wrist rest with palm bolster | 2 |
| `crimpdeq-platform-grip.stl` | Finger grip | 2 |

> [!NOTE]
> The frame comes as two halves because the full frame is 297.6 mm long and
> does not fit a 256 mm bed, even diagonally. The left half is 163.8 mm long
> and the right half 181.8 mm.

All parts are exported already oriented for printing. Don't rotate them or
use "Lay on face".

## Plate 1: frame halves

![Plate 1 layout](../images/plate1.png)

- Only the two frame halves, side by side with the long sides along Y.
- Leave about 15 mm between them. Don't nest one inside the other.
- Both halves print upside down: the flat rail faces on the bed and the feet
  pointing up.

## Plate 2: wrist rest and grip

![Plate 2 layout](../images/plate2.png)

Keep the parts at least 15–20 mm apart. **Print Plate 2 first.** It's
shorter, and it lets you check support removal before the long frame print.

## Print settings

Use one global process profile, then override per object where listed.

| Setting | Value |
|---|---|
| Layer height | 0.2 mm |
| Walls | 6 |
| Top/bottom layers | 6 |
| Infill | 40–60% for the frame halves |
| Supports | On, **Global**, type **tree(auto)**, threshold 30° |
| On build plate only | **Off** (the grip cheek needs support from the part) |
| Brim | Outer brim only, 5 mm |

Per-object override (select the object, switch Process to **Objects**):

| Object | Override |
|---|---|
| `grip`, `wrist_rest` | 100% infill |

PETG or ASA print well on the A1 and are enough to check fit and comfort.
PA-CF or PET-CF may be candidates for structural evaluation, but a filament
name or infill setting does not establish strength. Validate coupons in the
intended print orientation.

## Where supports are needed

| Part | Supported area |
|---|---|
| Right frame half | Underside of both lap tongues, about 22.5 mm up |
| Right frame half | Bridge over the palm-deck channel at the closed end |
| Left frame half | Clevis cheek with the Ø17 hole, about 35–45 mm up |
| Wrist rest | Underside of the overhanging heel deck and outer upper arms |
| Grip | Underside of the upper clevis cheek and pocket rim |

Nothing else needs support: the index holes are self-supporting, the screw
counterbores of the left half bridge over their holes, and the nut pockets
of the right half open upwards.

The right half's lap faces bear the rail load. Remove their support
carefully and sand them flat, without rounding the edges.
