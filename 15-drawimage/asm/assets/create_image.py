# create_image.py
# A simple script to generate a 64x64 pixel raw binary image for the Commander X16.

import sys

# --- Image Properties ---
WIDTH = 64
HEIGHT = 64
FILENAME = "draw_image.bin"

# --- X16 Default Palette Color Indexes ---
COLOR_PURPLE = 4
COLOR_YELLOW = 7
COLOR_WHITE = 1
BORDER_THICKNESS = 8

# Create a byte array to hold the pixel data
# It will be initialized with the purple fill color.
image_data = bytearray([COLOR_PURPLE] * (WIDTH * HEIGHT))

print(f"Generating {WIDTH}x{HEIGHT} image data...")

# --- Generate the Pattern ---
for y in range(HEIGHT):
    for x in range(WIDTH):
        pixel_index = y * WIDTH + x

        # Draw the yellow border
        if (x < BORDER_THICKNESS or x >= WIDTH - BORDER_THICKNESS or
            y < BORDER_THICKNESS or y >= HEIGHT - BORDER_THICKNESS):
            image_data[pixel_index] = COLOR_YELLOW

# Draw the white square in the center (32x32 pixels)
center_square_size = 32
offset = (WIDTH - center_square_size) // 2 # Should be 16 for a 64px image
for y in range(offset, offset + center_square_size):
    for x in range(offset, offset + center_square_size):
         pixel_index = y * WIDTH + x
         image_data[pixel_index] = COLOR_WHITE

# --- Write the binary file ---
try:
    with open(FILENAME, "wb") as f:
        f.write(image_data)
    print(f"Successfully created '{FILENAME}' ({len(image_data)} bytes).")
    print("You can now use this file with your assembly program.")
except IOError as e:
    print(f"Error: Could not write to file '{FILENAME}'.")
    print(e)
    sys.exit(1)