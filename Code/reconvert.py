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
    
    # Create files for R, G, B channels
    r_file, g_file, b_file = [open(file, 'w') for file in output_files]

    def map_to_binary(value):
        if value<33:
            return '00'
        elif (value<129 and value>32):
            return '01'
        elif (value<193 and value>128):
            return '10'
        elif (value>192) :
            return '11'
#        elif (value<161 and value>128) :
 #           return '001'
  #      elif (value<193 and value>160):
   #         return '011'
    #    elif (value<225 and value>192):
     #       return '101'
      #  elif value>224 :
       #     return '111'

    try:
        for y in range(height):
            for x in range(width):
                # Get RGB values
                r, g, b = pixels[x, y]
                
                # Convert RGB values to binary strings
                r_bin = map_to_binary(r)
                g_bin = map_to_binary(g)
                b_bin = map_to_binary(b)
                
                # Write to corresponding files
                r_file.write(f"{r_bin}"+",\n")
                g_file.write(f"{g_bin}"+",\n")
                b_file.write(f"{b_bin}"+",\n")
                
                #r_file.write(f"{r_bin}\n")
                #g_file.write(f"{g_bin}\n")
                #b_file.write(f"{b_bin}\n")
    
    finally:
        # Close all files
        r_file.close()
        g_file.close()
        b_file.close()

    print(f"Hex files {', '.join(output_files)} created successfully.")

# Example usage
convert_jpeg_to_hex(
    "/home/suchit/VideoCard/Gif/Frame2.png",
    ["red2.coe", "green2.coe", "blue2.coe"] 
    ##["output_r.txt", "output_g.txt", "output_b.txt"]
)

