# Printing

## Files

Each [release](https://github.com/crimpdeq/crimpdeq-platform/releases)
includes the STL files and `crimpdeq-platform.3mf`, a Bambu Studio project
with both plates laid out and the settings below applied. The project is set
up for a Bambu Lab A1 with a 0.4 mm nozzle, Generic PETG and the textured PEI
plate. Open it with **File → Open Project**, select your printer, filament
and plate, and print.

Take all the parts from the same release, or they may not fit together.

## Plates

![Plate 1: front base half, grip, anchor block and clips](../images/plate1.png)

![Plate 2: rear base half, palm rest, stoppers and key](../images/plate2.png)

The parts are exported already oriented for printing, so don't rotate them.
If you lay out the plates yourself, keep the parts at least 15 mm apart.

## Print settings

| Setting | Value |
|---|---|
| Layer height | 0.2 mm |
| Walls | 6 |
| Top/bottom layers | 6 |
| Infill | 20% |
| Supports | **Off** |
| Brim | Outer brim only, 5 mm |

Per-object overrides:

| Object | Override |
|---|---|
| `grip`, `anchor`, `clips`, `key` | 100% infill |
| `rest` | 50% infill |
| `base_front`, `base_rear` | 4 top and 4 bottom layers |

To save filament, the project also prints these lightly loaded zones
sparser, using height range modifiers:

| Object | Range | Infill |
|---|---|---|
| `base_front` | 22.6–59.6 mm | 10% |
| `rest` | 6–18 mm | 15% |
| `anchor` | 0–11.5 mm | 40% |

No part needs supports. Keep them off: they would scar the faces that the
load-cell eyes and the palm rest bear on.

After printing, remove the brims and trim any flared first layer on the base
halves' joint faces and on the palm rest's sole.
