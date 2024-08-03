from PIL import Image

def rgb_to_hex(rgb, channel):
    """Convert an RGB tuple to a hex string for a specific channel."""
    value = rgb[channel]
    return '{:02x}'.format(value)

def convert_image_to_hex_files(image_path, output_file_base):
    """Convert a PNG image to three hex files with RGB values in an 800x600 array format for each channel."""
    # Open the image
    with Image.open(image_path) as img:
        # Resize the image to 800x600 if necessary
        img = img.resize((800, 600))

        # Convert image to RGB (in case it's not in RGB mode)
        img = img.convert('RGB')

        # Get pixel data
        pixels = img.load()

        # File names for each channel
        output_files = {
            'R': f'{output_file_base}_R.hex',
            'G': f'{output_file_base}_G.hex',
            'B': f'{output_file_base}_B.hex'
        }

        # Open the output files for writing
        files = {key: open(output_files[key], 'w') for key in output_files}

        try:
            # Iterate through each pixel and write the hex values for each channel
            for y in range(600):
                for channel, file in files.items():
                    for x in range(800):
                        rgb = pixels[x, y]
                        if channel == 'R':
                            hex_value = rgb_to_hex(rgb, 0)
                        elif channel == 'G':
                            hex_value = rgb_to_hex(rgb, 1)
                        elif channel == 'B':
                            hex_value = rgb_to_hex(rgb, 2)
                        file.write(hex_value)
                        if x < 799:
                            file.write(' ')
                    file.write('\n')
        finally:
            # Close all files
            for file in files.values():
                file.close()

        print(f'Hex values have been written to {", ".join(output_files.values())}')

# Usage
image_path = '/home/suchit/VideoCard/Image2.png'  # Path to your PNG image
output_file_base = 'output_hex_array'  # Base name for output files
convert_image_to_hex_files(image_path, output_file_base)