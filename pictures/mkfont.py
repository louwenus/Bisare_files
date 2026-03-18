#!/bin/python

from fontTools.ttLib import TTFont
from PIL import Image, ImageDraw, ImageFont

COLUMNS, ROWS = 1,256
CHAR_WIDTH, CHAR_HEIGHT = 11, 16


font_path = "PixelOperator-Bold.ttf"
canvas = Image.new("1", (COLUMNS * CHAR_WIDTH, ROWS * CHAR_HEIGHT), color=0)

try:
    font = ImageFont.truetype(font_path, CHAR_HEIGHT)
    ttfont = TTFont(font_path)
    cmap = ttfont.getBestCmap()
    if cmap is None:
        raise Exception()
except Exception:
    print("The font can't be loaded")
    exit()

ranges = [
    range(ROWS * COLUMNS),
]

for range in ranges:
    for i in range:
        pos = i
        x = (pos % COLUMNS) * CHAR_WIDTH
        y = (pos // COLUMNS) * CHAR_HEIGHT

        char_to_draw = chr(i)
        if i < 32 or i not in cmap:
            char_to_draw = chr(0xFFFD)

        cell = Image.new("1", (CHAR_WIDTH, CHAR_HEIGHT), color=0)
        cell_draw = ImageDraw.Draw(cell)

        cell_draw.text((0, 0), char_to_draw, font=font, fill=1)
        canvas.paste(cell, (x, y))

canvas.save("fontplate_new.png")

