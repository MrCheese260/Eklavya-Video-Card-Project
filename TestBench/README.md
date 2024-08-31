# Video Card on FPGA report
## Introduction
This project focuses on the design and implementation of a video card using FPGA technology, capable of displaying images with up to 64 colors through an analog VGA interface. Unlike traditional video cards, which rely on proprietary designs, this project leverages the flexibility and power of FPGA-based development. The project highlights how FPGAs can be employed to create custom hardware solutions for video processing and display.


## Project Overview

This project involves the development of a custom video card on the Arty A7 35T FPGA board, designed to output images with a 64-color palette through an analog VGA interface. The FPGA is programmed using AMD Xilinx Vivado software.

The input images provided to the video card are originally 400x300 in resolution since the video card supports only that big of a resolution, but we interpolate the images using nearest neighbour interpolation to 800x600 resolution.The images are converted into 2-bit COE files, which are stored in the 1800 Kbit memory present on the FPGA. These files serve as the source for storing RGB values of pixels, which are then output to a display. The 64-color variety is achieved by using resistors.There are 4 intensity levels for each: Red green and blue which allowes a range of colors to be displayed on the screen.

The development of this project was supported by resources like the HDLbits website, the NANDLAND YouTube channel, and Chip Verify for learning Verilog. We were inspired to create this projet from Ben Eater's video, "The World's Worst Video Card."

## Acknowledgement

This project was brought to life thanks to the Eklavya mentorship program by SRA-VJTI, where continuous support and encouragement were provided at every stage. The availability of FPGA boards from SRA was essential, enabling us to explore and implement our ideas practically.

Our mentors, Saish Karole and Atharv Patil, were crucial in guiding us through the project. Their expertise and practical advice helped us overcome challenges and achieve our objectives efficiently.

The SRA-VJTI community provided a solid foundation for learning and problem-solving. Regular meetings and discussions with our mentors kept us on track and addressed any issues promptly. Additionally, we utilized Ben Eater's video as a valuable reference to guide our design and implementation.

## Contents
 1. <a href="#workflow">Workflow</a>
 2. <a href="#basics">Basics of the project</a>
    <ol style="list-style-type: none;">
    <li><a href="#fpgas"> What are FPGAs?</a></li>
    <li><a href="#why-fpgas"> So, why FPGAs?</a></li>
    <li><a href="#vga-interface"> What is a VGA interface</a></li>
            </ol>
 3. <a href="#image-processing">Image Processing</a>
    <ol style="list-style-type: none;">
    <li><a href="#color-conversion"> Image Processing and Color Conversion</a></li>
    <li><a href="#coe-generation"> COE File Generation</a></li>
    <li><a href="#merging-coe"> Merging COE Files</a></li>
    <li><a href="#file-cleanup"> File Cleanup</a></li>
            </ol>
 4. <a href="#verilog-code">Verilog Code Overview</a>
    <ol style="list-style-type: none;">
    <li><a href="#top-module"> Top Module(top.v)</a></li>
    <li><a href="#binary-loader"> Binary Loader(binary_loader.v)</a></li>
    <li><a href="#memory-modules"> Memory Modules</a></li>
            </ol>
 5. <a href="#conclusion">Conclusion</a>

## <section id="workflow">1. Workflow 
<ul>
    <li><b>Sync Signal Development</b>: Write and verify H_sync and V_sync signals to ensure proper synchronization for VGA display.</li>
    <li><b>COE File Creation</b>: Use Python to create COE files from your processed image data, converting images into a format compatible with your FPGA's memory.</li>
    <li><b>FPGA Integration</b>: Load the COE files onto the FPGA and deploy the design, ensuring that the FPGA correctly interprets the data for display.</li>
    <li><b>Display Output</b>: Process and display the image on the VGA interface, ensuring that the timing and color output match your expectations.</li>
    <li><b>Finalization</b>: Clean up temporary files, verify the design's functionality, and make any necessary adjustments for optimal performance.</li>
</ul>  
</section>

## <section id="basics">2. Basics of the Project
###  <section id="fpgas"> 2.1. What are FPGAs?
Field-Programmable Gate Arrays (FPGAs) are semiconductor devices that can be electronically reprogrammed to perform almost any function you want, unlike regular microprocessors, which run software instructions on fixed hardware architecture. This means you can design your own digital logic on an FPGA. 
    </section>
### <section id="why-fpgas"> 2.2. So, why FPGAs?
Building a video card is a complex task that involves handling data quickly and efficiently to display images on a screen. Field-Programmable Gate Arrays (FPGAs) are a powerful choice for projects like building a video card because they offer a unique blend of flexibility, performance, and customization that traditional processors simply can’t match. FPGAs can handle multiple operations simultaneously as well, making them ideal for tasks that require processing large amounts of data quickly, like rendering graphics or video streams. 
    </section>
###   <section id="vga-interface">2.3. What is a VGA interface?
VGA stands for Visual Graphics Array, and it is an interface to send information about the image from a computer’s video card to the monitor. VGA connectors are typically blue and have 15 pins arranged in three rows. This connector transmits the video signals from the computer to the monitor. Most of the pins used in the VGA are ground pins, but the pins we are most concerned with are the RGB pins (3 separate pins for red, green, and blue colors), as well as the horizontal and vertical sync pins. The RGB pins carry analog signals that provide information for the intensity of the red, green, and blue components of the image. By varying the voltage of each signal, different colors can be produced.The H_sync and V_sync signals synchronize the timing of the image data. H_sync signals the end of a line and the start of a new one, while V_sync signals the end of a frame and the beginning of a new one.
    </section>
<image src="https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/4d2d692ae98da5941f9a89440eace8e84e77b490/TestBench/VGA_interface.png" height ="500px" width ="1000px" align = "center"/>
    </section>
## <section id="image-processing">3. Image Processing
Python is utilized to preprocess image data and prepare it for use with the FPGA. The scripts handle resizing images, converting color values to a 2-bit format, and generating COE files required for FPGA initialization.
### <section id="color-conversion">3.1. Image Processing and Color Conversion
The script begins by opening an image file and ensuring it is in RGB mode. It then resizes the image to a standard resolution of 400x300 pixels, which aligns with the FPGA video card's display resolution. The script processes each pixel in the resized image, converting RGB color values to a 2-bit representation based on predefined intensity ranges. This conversion maps color intensities into four possible values, effectively reducing the color depth to 2 bits. The converted color values for the red, green, and blue channels are saved in separate text files.
    </section>
    
###   <section id="coe-generation">3.2. COE File Generation
Once the 2-bit values are generated, another part of the script reads these values from the text files and formats them into COE (Coefficient) files. COE files are used to initialize memory blocks in FPGA designs. The script writes the binary data into COE files, including radix information which specifies the type of data being loaded, which in this case is binary data. Each data value is separated by commas, with the final value followed by a semicolon to complete the file format.
    </section>
    
###  <section id="merging-coe">3.3. Merging COE Files
For projects requiring multiple image frames or channels, the script can merge COE files from different images. It reads the COE files for two images and appends the data from the second image to the COE files of the first image. This results in combined COE files that contain the image data from both sources. This step is essential to display multiple frames.
    </section>
###  <section id="file-cleanup">3.4. File Cleanup
To maintain a clean working environment, the script includes a cleanup function that deletes temporary and intermediate files created during processing. This includes files generated during image conversion and COE file creation. Removing these files ensures that only necessary outputs are retained, avoiding clutter and potential confusion.
    </section>
At the end of this whole process, we get 3 COE files, one for red values, one for blue values and one for green values of the pixels.They should ideally be 240002 lines long. 
</section>

## <section id="verilog-code">4. Verilog Code Overview
### <section id="top-module">4.1. Top Module (top.v)
The Top Module orchestrates the FPGA’s overall operation and integrates various components.The top module does 4 main tasks

<b>Clock Management</b>: It generates a secondary clock (new_clk) from the primary clock (clk). This secondary clock is used for VGA signal timing, ensuring proper synchronization with the VGA display.

<b>Synchronization Signal Generation</b>: The top module produces horizontal (h_sync_in) and vertical (v_sync_in) synchronization signals required for VGA output. These signals ensure that the image is correctly timed and displayed on the screen.

<b>Pixel Counting</b>: Maintains counters (count and reset_count) to track pixel positions and manage frame updates. These counters are reset periodically to ensure that the image is displayed correctly over time.

<b>Integration with Binary Loader</b>: The Top Module interfaces with the Binary Loader Module (binary_loader.v) to provide the VGA output with image data. It ensures that the pixel coordinates and synchronization signals are correctly communicated to the Binary Loader.
    </section>
    
### <section id="binary-loader"> 4.2. Binary Loader Module (binary_loader.v)
    
The Binary Loader Module is responsible for managing the retrieval of image data from memory and generating the appropriate VGA output signals. This module plays a critical role in converting the stored color data into a format suitable for display. Here's how it functions:

<b>Data Retrieval</b>: The Binary Loader Module utilizes a high-speed clock (clk_fast) to address the memory modules that store the 2-bit color values for each color channel (red, green, blue). The high-speed clock is necessary to handle the ROM's latency of 2 clock cycles, ensuring that data can be fetched efficiently despite the delay.

<b>Color Data Output</b>: Based on the pixel coordinates generated by the top module, the Binary Loader Module fetches the corresponding 2-bit color values from the RAM modules. It then sets the output color signals (red_1, green_1, blue_1) to match the color values retrieved from memory. This process ensures that the correct color is displayed for each pixel on the VGA output.

<b>Frame Switching</b>: This module supports multiple frames, allowing the display of different images or animation sequences. Frame switching is controlled by a frame_switcher signal, which toggles between different sets of image data. The frame_switcher enables the module to load and display different images or frames in response to external commands or predefined conditions.

<b>Interpolation</b>: During frame switching, the k variable is used for nearest neighbor interpolation, which is a technique that adjusts pixel values by mapping each pixel in the output image to the nearest pixel in the source image. By using the k variable, the algorithm calculates the nearest neighboring pixel from the source image to determine the color value for each pixel in the output image. This approach allows the image to be resized efficiently, maintaining its quality and aspect ratio while adapting to different display resolutions. Nearest neighbor interpolation with the k variable ensures that pixel values are scaled and mapped appropriately with minimal computational complexity.

The pixel data is only provided when h_sync and v_sync are within the given parameters, which here are 800 for h_sync and 600 for v_sync, whereas all the other times, the output is "00"
    </section>
    
### <section id= "#memory-modules"> 4.3. Memory Modules
The FPGA design incorporates dedicated memory modules for efficiently storing and accessing color data used in VGA output.These ROM modules are accessed sequentially during each pixel update cycle. When the VGA output needs to be refreshed, the FPGA reads the appropriate color values from these modules based on the current pixel coordinates. This ensures that the correct RGB values are provided to the VGA interface, allowing for accurate color representation on the screen.
    </section>
</section>

## <section id= "#conclusion"> 5.Conclusion
The development of a custom video card using the Arty A7 35T FPGA board has successfully demonstrated the versatility and power of FPGA technology in creating specialized hardware solutions. Through the integration of custom-built modules, including clock management, synchronization signal generation, and memory management, we created a robust system capable of handling image data efficiently. The use of Python for image preprocessing and COE file generation streamlined the workflow, ensuring that image data could be easily converted and loaded onto the FPGA.Below are a few images and GIFs that we have successfully displayed using the video-card

<image align ="center" src = "https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/47e4bf3617dd593337a938011b06de0b30c88d08/TestBench/Nyaan_Cat.gif" height="600px" width = "1000px"/>

<image align ="center" src = "https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/47e4bf3617dd593337a938011b06de0b30c88d08/TestBench/Lion_Image.jpg" height="600px" width = "1000px"/>

This project has not only deepened our understanding of FPGA design and video processing but also highlighted the importance of a systematic approach to hardware development. The knowledge and skills gained from this project will serve as a solid foundation for future endeavors in digital design and FPGA-based development.
</section>
