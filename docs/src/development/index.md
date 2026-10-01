# Development

The model is plain OpenSCAD with no library dependencies:

- `dynamometer_dimensions.scad`: parameters and structural assertions.
- `dynamometer_parts.scad`: the printable parts.
- `dynamometer_assembly.scad`: preview and export entry point.
- `crimpdeq_reference.scad`: a simplified snapshot of the Crimpdeq case
  (crimpdeq-case v2.0.0) used for fit and collision checks.

All dimensions are in millimetres. Override parameters with `-D name=value`;
unsafe combinations fail with an assertion.

## Preview and export

```bash
openscad dynamometer_assembly.scad    # preview; options in Window → Customizer
bash export-parts.sh                  # every part as STL into exports/
python3 export-bambu-project.py       # Bambu Studio project into exports/
```

## Validate

Run after every geometry or dimension change:

```bash
CHECK_JOBS=4 OPENSCAD_RENDER_FN=24 bash check-collisions.sh
```

It checks the parts for collisions and required contacts, confirms that each
exported STL has the expected number of bodies, and that unsafe parameters
are rejected. `check-real-case.sh` runs the same fit checks against the real
[crimpdeq-case](https://github.com/crimpdeq/crimpdeq-case) source. CI runs
both on every pull request.

## Book

The images in `docs/src/images/` are rendered from the model; re-render them
after geometry changes and preview the book:

```bash
bash docs/illustrations/render-illustrations.sh
mdbook serve docs
```
