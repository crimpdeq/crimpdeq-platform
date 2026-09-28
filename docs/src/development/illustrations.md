# Illustrations

Every picture in `docs/src/images/` is rendered from the project's OpenSCAD
model, so re-render them after geometry changes. Rendering needs OpenSCAD,
ImageMagick (`magick`), and Python with NumPy and Pillow.

OpenSCAD cannot export transparent PNGs, so each view is rendered twice, on a
light and a black background, and `matte.py` derives the transparency from
the difference. Every object in a scene must therefore have an explicit
colour; use `c_ghost` rather than the `%` modifier for see-through context.

```bash
bash docs/illustrations/render-illustrations.sh             # all views
bash docs/illustrations/render-illustrations.sh join_base case_in  # selected views
python3 docs/illustrations/make-legend.py                   # colour key
```

Scenes live in `docs/illustrations/illustrations.scad`, selected with
`view="..."`. Keep the colours in `make-legend.py` in sync with its `c_*`
values.

Build or preview the book with [mdBook](https://rust-lang.github.io/mdBook/):

```bash
mdbook serve docs
```
