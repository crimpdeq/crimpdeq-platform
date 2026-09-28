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
output directory, parallel jobs, and tessellation. `ON_PLATE=true` (or
`-D on_plate=true` in OpenSCAD) exports each part where it sits on its print
plate instead, using the layout in `print_plate_placement()` that the book's
plate images also use.

`export-bambu-project.py` builds the Bambu Studio project
`exports/crimpdeq-platform.3mf`. It exports the parts on their plates, checks
that each part and its brim stay on the bed and that parts sharing a plate
are at least 15 mm apart, and has the Bambu Studio command-line interface lay
out the three plates with the settings from [Printing](../build/printing.md).
It then slices every plate to confirm that the project is printable
(`--skip-slice` skips this). It needs Bambu Studio: the macOS application is
found automatically; elsewhere put `bambu-studio` on `PATH` or set
`BAMBU_STUDIO`, and `BAMBU_STUDIO_PROFILES` if its profiles aren't found.
The printer, process and filament presets and the setting overrides are at
the top of the script.

The release workflow runs both scripts, checks that each load-bearing part is
one body and the stoppers two, and attaches the STL files and the project to
each GitHub release. It uses the Bambu Studio version pinned in
`.github/actions/setup-bambu-studio/action.yml`. Run it from the Actions tab
(**Release Crimpdeq Platform → Run workflow**) for a dry run: it builds and
checks the files and keeps them as a run artifact, without publishing
anything.

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
