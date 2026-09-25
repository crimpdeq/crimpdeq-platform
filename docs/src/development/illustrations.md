# Illustrations

Every picture in `docs/src/images/` is rendered from the project's OpenSCAD
model, so re-render them after geometry changes. Rendering needs OpenSCAD and
ImageMagick (`magick`); the colour key needs Python with Pillow.

```bash
bash docs/illustrations/render-illustrations.sh             # all views
bash docs/illustrations/render-illustrations.sh glue case_in  # selected views
python3 docs/illustrations/make-legend.py                   # colour key
```

Scenes live in `docs/illustrations/illustrations.scad`, selected with
`view="..."`. Keep the colours in `make-legend.py` in sync with its `c_*`
values.

Build or preview the book with [mdBook](https://rust-lang.github.io/mdBook/):

```bash
mdbook serve docs
```
