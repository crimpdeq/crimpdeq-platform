# Previewing and exporting

Open the assembly preview:

```bash
openscad dynamometer_assembly.scad
```

Select a part with `part` to export it:

```bash
openscad -D 'part="frame"' -o /tmp/dynamometer_frame.stl dynamometer_assembly.scad
```

| `part` | Contents |
| --- | --- |
| `assembly` | Full preview (default) |
| `frame` | One-piece frame |
| `grip` | Moving hangboard grip |
| `wrist_rest` | Adjustable palm and wrist saddle |
| `pin_spacer_pair` | Unloaded fit replicas of the steel sleeves, **not** load-bearing |
| `frame_left`, `frame_right` | Split frame halves, fit prototype only |
| `frame_split_pegs`, `frame_split_braces` | Split-frame pegs and seam braces |
| `fit_bolt_set` | Printed M8 bolt, nut, and washer stand-ins, fit prototype only |
| `fit_quick_pin_pair` | Printed ball-lock pin stand-ins, fit prototype only |

The [fit prototype](../fit-prototype/what-to-print.md) chapter lists the
command that exports every part it needs into `exports/`, which is ignored by
Git.

## Preview options

```bash
openscad -D 'pose="rated"' dynamometer_assembly.scad
openscad -D 'pose="exploded"' dynamometer_assembly.scad
openscad -D 'wrist_position=-1' dynamometer_assembly.scad
openscad -D 'show_split_braces=true' dynamometer_assembly.scad
```

The rated pose exaggerates displacement for visualisation and does not change
exported parts. `wrist_position` previews the nearest physical index from `-1`
(smallest opening) to `1` (largest opening). `show_case`, `show_internals`,
`show_hardware`, and `show_wrist_rest` toggle the corresponding preview
geometry.
