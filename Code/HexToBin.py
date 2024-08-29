from PIL import Image

def convert_jpeg_to_hex(image_path, output_file):
    # Open the JPEG image
    img = Image.open(image_path)
    
    # Convert the image to RGB mode if it's not already in that mode
    img = img.convert('RGB')
    
    # Get the image dimensions
    width, height = img.size
    
    # Load the pixel data
    pixels = img.load()

    with open(output_file, 'w') as hex_file:
        for y in range(height):
            for x in range(width):
                # Get RGB values
                r, g, b = pixels[x, y]
                
                # Function to map the RGB values to binary
                def map_to_binary(value):
                    if value < 33:
                        return '00'
                    elif value < 129:
                        return '01'
                    elif value < 192:
                        return '10'
                    else:
                        return '11'
                
                # Convert RGB values to binary strings
                r_bin = map_to_binary(r)
                g_bin = map_to_binary(g)
                b_bin = map_to_binary(b)
                
                # Combine binary values and convert to hexadecimal string
                combined_bin = r_bin + g_bin + b_bin
                combined_hex = format(int(combined_bin, 2), '06x')
                
                # Write to file
                hex_file.write(f"{combined_hex}\n")

    print(f"Hex file {output_file} created successfully.")

# Example usage
convert_jpeg_to_hex("C:/Users/sarve/Downloads/sra_11.jpg", "output_image.hex")

