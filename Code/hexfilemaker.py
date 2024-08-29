from PIL import Image

def convert_jpeg_to_hex(image_path, output_files):
    # Open the JPEG image
    img = Image.open(image_path)
    
    # Convert the image to RGB mode if it's not already in that mode
    img = img.convert('RGB')
    
    # Get the image dimensions
    width, height = img.size
    
    # Load the pixel data
    pixels = img.load()
    
    # Create files for R, G, B channels in binary and hex
    r_bin_file, g_bin_file, b_bin_file, r_hex_file, g_hex_file, b_hex_file = [open(file, 'w') for file in output_files]

    def map_to_binary(value):
        if value < 33:
            return '00'
        elif value < 129:
            return '01'
        elif value < 192:
            return '10'
        else:
            return '11'

    try:
        for y in range(height):
            for x in range(width):
                # Get RGB values
                r, g, b = pixels[x, y]
                
                # Convert RGB values to binary strings
                r_bin = map_to_binary(r)
                g_bin = map_to_binary(g)
                b_bin = map_to_binary(b)
                
                # Write binary values to corresponding files
                r_bin_file.write(f"{r_bin}\n")
                g_bin_file.write(f"{g_bin}\n")
                b_bin_file.write(f"{b_bin}\n")
                
                # Convert RGB values to hex and write to corresponding files
                r_hex_file.write(f"{r:02X}\n")
                g_hex_file.write(f"{g:02X}\n")
                b_hex_file.write(f"{b:02X}\n")
    
    finally:
        # Close all files
        r_bin_file.close()
        g_bin_file.close()
        b_bin_file.close()
        r_hex_file.close()
        g_hex_file.close()
        b_hex_file.close()

    print(f"Files {', '.join(output_files)} created successfully.")

# Example usage
convert_jpeg_to_hex(
    "/home/suchit/VideoCard/400x300.png", 
    ["output_r_bin.txt", "output_g_bin.txt", "output_b_bin.txt", 
     "output_r_hex.txt", "output_g_hex.txt", "output_b_hex.txt"]
)

