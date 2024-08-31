import os
from PIL import Image

# Function to convert an 8-bit RGB value (0-255) to a 2-bit value (00, 01, 10, 11)
def convert_to_2bit(value):
    if 0 <= value <= 33:
        return '00'
    elif 34 <= value <= 128:
        return '01'
    elif 129 <= value <= 192:
        return '10'
    elif 193 <= value <= 255:
        return '11'

# Function to process an image and convert its RGB values to 2-bit values
# These 2-bit values are written to separate files for the red, green, and blue channels
def process_image(image_path, red_file, green_file, blue_file):
    # Open the image file
    image = Image.open(image_path)
    image = image.convert('RGB')  # Ensure image is in RGB mode

    # Resize the image to 400x300 (ensuring it fits into the FPGA display resolution)
    image = image.resize((400, 300))
    
    # Get the dimensions of the resized image
    width, height = image.size

    # Open files to write the 2-bit values for each channel
    with open(red_file, 'w') as red_f, \
         open(green_file, 'w') as green_f, \
         open(blue_file, 'w') as blue_f:
        
        # Loop through each pixel in the image
        for y in range(height):
            for x in range(width):
                r, g, b = image.getpixel((x, y))  # Get the RGB values of the current pixel
                
                # Write the 2-bit equivalent of the RGB values to the corresponding files
                red_f.write(f"{convert_to_2bit(r)}\n")
                green_f.write(f"{convert_to_2bit(g)}\n")
                blue_f.write(f"{convert_to_2bit(b)}\n")
                
    print(f"RGB values from {image_path} have been converted to 2-bit and saved.")

# Function to generate a COE file from the 2-bit RGB values stored in a text file
def generate_coe(input_file, output_file):
    # Define the radix for binary data
    radix = 2
    
    # Read the input file containing 2-bit values
    with open(input_file, 'r') as infile:
        # Read all lines and strip any extra whitespace or newline characters
        data = [line.strip() for line in infile if line.strip()]
    
    # Write the COE file with the appropriate header and binary data
    with open(output_file, 'w') as outfile:
        # Write the radix information with a semicolon
        outfile.write(f"memory_initialization_radix={radix};\n")
        outfile.write("memory_initialization_vector=\n")
        
        # Write the data values with commas separating them
        for i in range(len(data) - 1):
            outfile.write(f"{data[i]},\n")
        
        # Write the last data value with a semicolon to mark the end of the vector
        outfile.write(f"{data[-1]};\n")

# Function to merge and update existing COE files with new data from a second image
def merge_and_update_coe(red1_file, green1_file, blue1_file, red2_file, green2_file, blue2_file):
    # Helper function to read only the data from a COE file, ignoring the header
    def read_data_only(file_path):
        with open(file_path, 'r') as f:
            # Skip the first two lines (radix and vector declaration)
            lines = f.readlines()[2:]
            return [line.strip().rstrip(',;') for line in lines if line.strip()]

    # Read the data from the second set of COE files
    red2_data = read_data_only(red2_file)
    green2_data = read_data_only(green2_file)
    blue2_data = read_data_only(blue2_file)

    # Helper function to append new data to an existing COE file
    def append_data_to_file(base_file, data_list):
        with open(base_file, 'r+') as f:
            lines = f.readlines()
            # Find the line with the last data value (just before the semicolon)
            last_line_index = len(lines) - 1
            while not lines[last_line_index].strip().endswith(';'):
                last_line_index -= 1
            
            # Remove the semicolon from the last data line to allow more data to be added
            lines[last_line_index] = lines[last_line_index].replace(';', ',')
            
            # Add new data to the end, ensuring each new data is on its own line
            for data in data_list[:-1]:
                lines.append(f"{data},\n")
            lines.append(f"{data_list[-1]};\n")  # Add the final data with a semicolon
            
            # Rewrite the updated content back to the file
            f.seek(0)
            f.writelines(lines)

    # Append the new data to the existing COE files for red, green, and blue channels
    append_data_to_file(red1_file, red2_data)
    append_data_to_file(green1_file, green2_data)
    append_data_to_file(blue1_file, blue2_data)

    print("COE files have been updated with data from the second image.")

# Function to delete temporary and intermediate files after processing
def cleanup_files(files):
    for file in files:
        if os.path.exists(file):
            os.remove(file)
            print(f"Deleted temporary file: {file}")

# Main function to execute the entire process
def main():
    # Prompt the user for file paths of the two images to process
    image1_path = input("Enter the path to the first image file: ").strip().strip('"')
    image2_path = input("Enter the path to the second image file: ").strip().strip('"')
    
    # Define temporary files for intermediate results
    red1_temp = 'red1_temp.txt'
    green1_temp = 'green1_temp.txt'
    blue1_temp = 'blue1_temp.txt'
    red2_temp = 'red2.txt'
    green2_temp = 'green2.txt'
    blue2_temp = 'blue2.txt'

    # Define output COE files for the final result
    red1_file = 'red1.coe'
    green1_file = 'green1.coe'
    blue1_file = 'blue1.coe'

    # Process the first image and generate COE files for each color channel
    process_image(image1_path, red1_temp, green1_temp, blue1_temp)
    generate_coe(red1_temp, red1_file)
    generate_coe(green1_temp, green1_file)
    generate_coe(blue1_temp, blue1_file)

    # Process the second image and generate COE files for each color channel
    process_image(image2_path, red2_temp, green2_temp, blue2_temp)
    generate_coe(red2_temp, 'red2.coe')
    generate_coe(green2_temp, 'green2.coe')
    generate_coe(blue2_temp, 'blue2.coe')

    # Merge and update the COE files from the first image with data from the second image
    merge_and_update_coe(red1_file, green1_file, blue1_file, 'red2.coe', 'green2.coe', 'blue2.coe')

    # Clean up temporary and intermediate files used during processing
    cleanup_files([red1_temp, green1_temp, blue1_temp, red2_temp, green2_temp, blue2_temp, 'red2.coe', 'green2.coe', 'blue2.coe'])

if __name__ == "__main__":
    main()
