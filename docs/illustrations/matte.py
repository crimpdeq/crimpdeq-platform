#!/usr/bin/env python3
"""Combine light- and black-background renders into one transparent PNG.

OpenSCAD cannot export transparent images, so each view is rendered twice
(render-illustrations.sh). Where the two renders differ, the background shows
through; the difference gives the alpha, which also keeps the translucent case
and ghost parts see-through.

Usage: matte.py LIGHT.png BLACK.png OUT.png
"""
import sys

import numpy as np
from PIL import Image

# Background of OpenSCAD's "Tomorrow" colour scheme; "Starnight" is black.
LIGHT_BG = 248 / 255


def main():
    light_path, black_path, out_path = sys.argv[1:]
    light = np.asarray(Image.open(light_path).convert("RGB"), dtype=np.float64) / 255
    black = np.asarray(Image.open(black_path).convert("RGB"), dtype=np.float64) / 255
    if light.shape != black.shape:
        sys.exit(f"{light_path} and {black_path} differ in size")

    # light = a*c + (1-a)*LIGHT_BG and black = a*c, so light - black = (1-a)*LIGHT_BG.
    alpha = np.clip(1 - (light - black).mean(axis=2) / LIGHT_BG, 0, 1)
    colour = np.clip(black / np.maximum(alpha, 1e-6)[..., None], 0, 1)
    rgba = np.dstack([colour, alpha]) * 255
    Image.fromarray(np.round(rgba).astype(np.uint8), "RGBA").save(out_path)


if __name__ == "__main__":
    main()
