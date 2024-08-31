import os
from PIL import Image

def convert_to_2bit(value):
    if 0 <= value <= 33:
        return '00'
    elif 34 <= value <= 128:
        return '01'
    elif 129 <= value <= 192:
        return '10'
    elif 193 <= value <= 255:
        return '11'

def process_image(image_path, red_file, green_file, blue_file):
    # Open the image file
    image = Image.open(image_path)
    image = image.convert('RGB')  # Ensure image is in RGB mode

    # Resize the image to 400x300
    image = image.resize((400, 300))
    
    # Get the dimensions of the resized image
    width, height = image.size

    # Open files to write the 2-bit values for each channel
    with open(red_file, 'w') as red_f, \
         open(green_file, 'w') as green_f, \
         open(blue_file, 'w') as blue_f:
        
        for y in range(height):
            for x in range(width):
                r, g, b = image.getpixel((x, y))
                
                red_f.write(f"{convert_to_2bit(r)}\n")
                green_f.write(f"{convert_to_2bit(g)}\n")
                blue_f.write(f"{convert_to_2bit(b)}\n")
                
    print(f"RGB values from {image_path} have been converted to 2-bit and saved.")

def generate_coe(input_file, output_file):
    # Define the radix for binary data
    radix = 2
    
    # Read the input file
    with open(input_file, 'r') as infile:
        # Read all lines and strip any extra whitespace or newline characters
        data = [line.strip() for line in infile if line.strip()]
    
    # Write the COE file
    with open(output_file, 'w') as outfile:
        # Write the radix information with a semicolon
        outfile.write(f"memory_initialization_radix={radix};\n")
        outfile.write("memory_initialization_vector=\n")
        
        # Write the data values with commas
        for i in range(len(data) - 1):
            outfile.write(f"{data[i]},\n")
        
        # Write the last data value with a semicolon
        outfile.write(f"{data[-1]};\n")

def merge_and_update_coe(red1_file, green1_file, blue1_file, red2_file, green2_file, blue2_file):
    def read_data_only(file_path):
        with open(file_path, 'r') as f:
            # Skip the first two lines (radix and vector declaration)
            lines = f.readlines()[2:]
            return [line.strip().rstrip(',;') for line in lines if line.strip()]

    red2_data = read_data_only(red2_file)
    green2_data = read_data_only(green2_file)
    blue2_data = read_data_only(blue2_file)

    def append_data_to_file(base_file, data_list):
        with open(base_file, 'r+') as f:
            lines = f.readlines()
            # Find the line with the last data value (just before the semicolon)
            last_line_index = len(lines) - 1
            while not lines[last_line_index].strip().endswith(';'):
                last_line_index -= 1
            
            # Remove the semicolon from the last data line
            lines[last_line_index] = lines[last_line_index].replace(';', ',')
            
            # Add new data to the end, ensuring each new data is on its own line
            for data in data_list[:-1]:
                lines.append(f"{data},\n")
            lines.append(f"{data_list[-1]};\n")
            
            # Rewrite the file
            f.seek(0)
            f.writelines(lines)

    append_data_to_file(red1_file, red2_data)
    append_data_to_file(green1_file, green2_data)
    append_data_to_file(blue1_file, blue2_data)

    print("COE files have been updated with data from the second image.")

def cleanup_files(files):
    for file in files:
        if os.path.exists(file):
            os.remove(file)
            print(f"Deleted temporary file: {file}")

def main():
    # Prompt the user for file paths
    image1_path = input("Enter the path to the first image file: ").strip().strip('"')
    image2_path = input("Enter the path to the second image file: ").strip().strip('"')
    
    # Temporary files for intermediate results
    red1_temp = 'red1_temp.txt'
    green1_temp = 'green1_temp.txt'
    blue1_temp = 'blue1_temp.txt'
    red2_temp = 'red2.txt'
    green2_temp = 'green2.txt'
    blue2_temp = 'blue2.txt'

    # Output COE files
    red1_file = 'red1.coe'
    green1_file = 'green1.coe'
    blue1_file = 'blue1.coe'

    # Process the first image
    process_image(image1_path, red1_temp, green1_temp, blue1_temp)
    generate_coe(red1_temp, red1_file)
    generate_coe(green1_temp, green1_file)
    generate_coe(blue1_temp, blue1_file)

    # Process the second image
    process_image(image2_path, red2_temp, green2_temp, blue2_temp)
    generate_coe(red2_temp, 'red2.coe')
    generate_coe(green2_temp, 'green2.coe')
    generate_coe(blue2_temp, 'blue2.coe')

    # Merge and update COE files
    merge_and_update_coe(red1_file, green1_file, blue1_file, 'red2.coe', 'green2.coe', 'blue2.coe')

    # Cleanup temporary and intermediate files
    cleanup_files([red1_temp, green1_temp, blue1_temp, red2_temp, green2_temp, blue2_temp, 'red2.coe', 'green2.coe', 'blue2.coe'])

if __name__ == "__main__":
    main()
