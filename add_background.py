import os
import sys

try:
    from PIL import Image
except ImportError:
    print("PIL not found, please install Pillow")
    sys.exit(1)

def add_background(input_path, output_path, color):
    img = Image.open(input_path).convert("RGBA")
    background = Image.new("RGBA", img.size, color)
    combined = Image.alpha_composite(background, img)
    combined.convert("RGB").save(output_path, "PNG")
    print(f"Saved to {output_path}")

# Pastel Pink: #FFD1DC -> (255, 209, 220)
# Or a slightly more vibrant cute pink: #FFB7C5 (Cherry Blossom)
# Let's go with a nice LightPink #FFB6C1 (255, 182, 193)
add_background("Sources/Resources/panda.png", "Sources/Resources/panda_pink.png", (255, 192, 203, 255))
