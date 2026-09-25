#!/usr/bin/env python3
"""Draw the colour key used by the book illustrations (../src/images/legend.png).

Keep the colours in sync with the c_* values in illustrations.scad.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ITEMS = [
    ("Frame (left / right half)", [(0.40, 0.42, 0.46), (0.58, 0.60, 0.64)]),
    ("Finger grip", [(0.20, 0.45, 0.78)]),
    ("Wrist rest", [(0.95, 0.55, 0.15)]),
    ("Crimpdeq case (see-through)", [(0.12, 0.20, 0.32)]),
    ("Printed spacers", [(0.92, 0.76, 0.20)]),
    ("Printed bolts, nuts, washers", [(0.82, 0.82, 0.86)]),
    ("Printed wrist pins", [(0.45, 0.80, 0.45)]),
    ("Frame pegs", [(0.20, 0.75, 0.70)]),
    ("Seam braces", [(0.52, 0.42, 0.76)]),
    ("Paperclip retainer", [(0.72, 0.42, 0.18)]),
    ("Glue faces", [(0.85, 0.20, 0.80)]),
    ("Movement arrows", [(0.90, 0.10, 0.10)]),
]
FONTS = [
    "/usr/share/fonts/TTF/DejaVuSans.ttf",
    "/usr/share/fonts/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
]


def load_font(size):
    for path in FONTS:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            pass
    return ImageFont.load_default()


def main():
    font = load_font(26)
    cols, row_h, col_w, pad = 2, 52, 560, 30
    rows = (len(ITEMS) + cols - 1) // cols
    img = Image.new("RGBA", (cols * col_w + pad, rows * row_h + 2 * pad), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    for i, (label, colours) in enumerate(ITEMS):
        x = pad + (i // rows) * col_w
        y = pad + (i % rows) * row_h
        for j, colour in enumerate(colours):
            draw.rounded_rectangle(
                [x + j * 22, y + 6, x + j * 22 + 34, y + 40], 6,
                fill=tuple(int(v * 255) for v in colour), outline=(90, 90, 90),
            )
        text_x = x + 34 + 22 * (len(colours) - 1) + 16
        # Mid-grey text, matching c_text, reads on light and dark pages.
        draw.text((text_x, y + 8), label, fill=(117, 120, 133), font=font)
    out = Path(__file__).resolve().parent.parent / "src" / "images" / "legend.png"
    img.save(out)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
