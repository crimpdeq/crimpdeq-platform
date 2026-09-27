# Previewing and exporting

Open the assembly preview:

```bash
openscad dynamometer_assembly.scad
```

Select a part with `part` to export it:

```bash
openscad -D 'part="frame_left"' -o /tmp/dynamometer_frame_left.stl dynamometer_assembly.scad
```

| `part` | Contents |
| --- | --- |
| `assembly` | Full preview (default) |
| `frame_left`, `frame_right` | Frame halves, joined by bolted lap joints |
| `grip` | Moving hangboard grip |
| `wrist_rest` | Adjustable palm and wrist saddle |
| `stoppers` | Two stackable pocket stoppers, laid out flat |

`export-parts.sh` exports every part in the table (or only the parts given as
arguments) as `crimpdeq-platform-<part>.stl` into `exports/`, which is ignored
by Git. `EXPORT_DIR`, `EXPORT_JOBS`, and `OPENSCAD_RENDER_FN` override the
output directory, parallel jobs, and tessellation. The release workflow runs
the same script, checks that each load-bearing part is one body and the
stoppers two, and attaches the files to each GitHub release. Run it from the
Actions tab (**Release Crimpdeq Platform → Run workflow**) for a dry run: it
builds and checks the files and keeps them as a run artifact, without
publishing anything.

## Preview options

The view options appear in OpenSCAD's Customizer (**Window → Customizer**)
when `dynamometer_assembly.scad` is open: pick the part and pose from lists,
drag the wrist position, and tick what to show. On the command line, set
them with `-D`:

```bash
openscad -D 'pose="rated"' dynamometer_assembly.scad
openscad -D 'pose="exploded"' dynamometer_assembly.scad
openscad -D 'wrist_position=-1' dynamometer_assembly.scad
openscad -D 'pocket_stoppers="both"' dynamometer_assembly.scad
```

The rated pose exaggerates displacement for visualisation and does not change
exported parts. `wrist_position` previews the nearest physical index from `-1`
(smallest opening) to `1` (largest opening). `show_case`, `show_internals`,
`show_hardware`, `show_wrist_rest`, `show_stoppers`, and `show_phone` (off by
default) toggle the corresponding preview geometry. `pocket_stoppers` fits the
5 mm stopper, the 10 mm stopper, or both stacked in the finger pocket
(`"none"`, `"5"`, `"10"`, `"both"`); the others stay in their storage well.
