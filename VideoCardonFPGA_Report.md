# Video Card on FPGA report
## Introduction
This project focuses on the design and implementation of a video card using FPGA technology, capable of displaying images with up to 64 colors through an analog VGA interface. Unlike traditional video cards, which rely on proprietary designs, this project leverages the flexibility and power of FPGA-based development. The project highlights how FPGAs can be employed to create custom hardware solutions for video processing and display.


## Project Overview

This project involves the development of a custom video card on the Arty A7 35T FPGA board, designed to output images with a 64-color palette through an analog VGA interface. The FPGA is programmed using AMD Xilinx Vivado software.

The input images provided to the video card are originally 400x300 in resolution since the FPGA we have used has memory constraints, we interpolate the images using nearest neighbour interpolation from 400x300 to 800x600 resolution.The images are converted into 2-bit values that are stored in COE files, which are stored in the 1800 Kbit memory present on the FPGA. These files serve as the source for storing RGB values of pixels, which are then output to a display. The 64-color variety is achieved by using resistors.There are 4 intensity levels for each: Red, green, and blue, which allows a range of colors to be displayed on the screen.

Resources such as the HDLbits website, the NANDLAND YouTube channel, and Chip Verify were instrumental in the development of this project. We were inspired to create this project from Ben Eater's video, "The World's Worst Video Card."

## Contents
 1. <a href="#workflow">Workflow</a>
 2. <a href="#basics">Basics of the project</a>
    <ol style="list-style-type: none;">
    <li><a href="#fpgas"> What are FPGAs?</a></li>
    <li><a href="#why-fpgas"> So, why FPGAs?</a></li>
    <li><a href="#vga-interface"> What is a VGA interface</a></li>
    <li><a href="#resistor-combination"> Resistor combinations</a></li>
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
 6. <a href="#acknowledgement">Acknowledgement</a>

## <section id="workflow">1. Workflow 
<ul>
    <li><b>Sync Signal Development</b>:  To guarantee correct synchronization for VGA display, write and check the H_sync and V_sync signals.</li>
    <li><b>COE File Creation</b>: To transform your processed image data into a format that is compatible with the memory of your FPGA, use Python to produce COE files.</li>
    <li><b>FPGA Integration</b>: Install the design on the FPGA and load the COE files onto it to make sure the FPGA understands the data properly for display.</li>
    <li><b>Display Output</b>: Verify that the timing and color output of the image meet your expectations when you process and display it on the VGA interface.</li>
    <li><b>Finalization</b>: Delete temporary files, check that the design works as intended, and make any performance-enhancing changes that are needed.</li>
</ul>  
</section>
<image src="https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/159f3ee870a3841550c13b3ace609c047784da3b/assets/Flowhcart_workflow.png" height ="142px" width ="500px" align = "center"/>
 
## <section id="basics">2. Basics of the Project
###  <section id="fpgas"> 2.1. What are FPGAs?
Unlike conventional microprocessors, which execute software instructions on set hardware architecture, Field-Programmable Gate Arrays (FPGAs) are semiconductor devices that can be electronically reprogrammed to perform nearly any function you need. This implies that you can use an FPGA to create your own digital logic.
    </section>
### <section id="why-fpgas"> 2.2. So, why FPGAs?
Constructing a video card is a challenging endeavor that calls for handling data fast and effectively in order to show images on a screen. For tasks like constructing a video card, Field-Programmable Gate Arrays (FPGAs) are an excellent option since they provide a special combination of performance, customisation, and flexibility that conventional processors just cannot match. FPGAs are perfect for activities that require processing big volumes of data quickly, such as producing images or videos, because they can handle numerous processes at once. 
    </section>
###   <section id="vga-interface">2.3. What is a VGA interface?
The Visual Graphics Array, or VGA, is an interface that allows data about an image to be sent from a computer's video card to the monitor. VGA connectors contain 15 pins organized in three rows and are usually blue in color. The video signals are sent from the computer to the monitor via this connector. Although ground pins make up the majority of the pins utilized in the VGA, the pins that we are most worried about are the RGB pins (three distinct pins for the colors red, green, and blue) and the horizontal and vertical sync pins. Analog signals that indicate the intensity of the image's red, green, and blue components are carried by the RGB pins. It is possible to create multiple hues by altering the voltage of each signal.
    </section>
<image src="https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/fcc8ff8beb741ebb41a7290043ae588f4ab5669c/assets/VGA_interface.png" height ="500px" width ="1000px" align = "center"/>
    </section>
### <section id="resistor-combinations"> 2.4. Resistor combinations
By regulating the analog voltage levels supplied to a display, resistors in the VGA interface aid in the determination of color intensity. They are a component of a digital-to-analog converter (DAC), which converts digital color data into red, green, and blue signal voltages. On analog displays like VGA, the resistors produce exact voltage levels that correspond to distinct intensities for each color channel, enabling accurate color reproduction. Digital circuits play this job instead in contemporary digital systems. For every color channel, there is a maximum voltage of 0.7V permitted. In our project, the voltage levels that are defined are 0V, 0.175V, 0.35V, and 0.7V. This results in four indexing ranges: 0V for the first 32 color values, 0.175V for the next 94 color values, 0.35 for the next 64 color values, and 0.7V for the final 64 color values.
The combination of the resistors (1300 ohm and 680 ohm) that we utilized produces four color intensities for each channel, which in turn produces different over-colors, ultimately yielding 64 colors.
    </section>
## <section id="image-processing">3. Image Processing
Python is utilized to preprocess image data and prepare it for use with the FPGA. The scripts handle resizing images, converting color values to a 2-bit format, and generating COE files required for FPGA initialization.
### <section id="color-conversion">3.1. Image Processing and Color Conversion
Opening an image file and making sure it is in RGB mode is the first step in the script. After that, it resizes the picture to 400x300 pixels, the typical resolution of the FPGA video card's display. Based on predetermined intensity ranges, the script processes each pixel in the scaled image, transforming RGB color values to a 2-bit representation. This conversion reduces the color depth to two bits by mapping color intensities into four potential values. Three distinct text files provide the converted color values for the red, green, and blue channels.
Pillow is a Python library for image processing used for image processing, which offers tools to open, manipulate, and save images in various formats. It supports tasks like resizing, cropping, filtering, and converting images and is easily installed with pip.
    </section>
    
###   <section id="coe-generation">3.2. COE File Generation
An additional portion of the script reads the 2-bit values from the text files and formats them into COE (Coefficient) files when they are generated. Text files called COE (Coefficient) files are used by FPGA design tools to set the starting values of memory elements such as lookup tables and block RAMs. These files include data in a format that can be read by synthesis tools, such as pixel values, filter coefficients, or other constants. By assisting with the initialization of memory content, COE files make sure that the FPGA boots up or resets with predetermined data. The script loads the binary data, together with radix metadata that indicates the type of data being loaded (binary data in this example), into COE files. Each data value is separated by commas, with the final value followed by a semicolon to complete the file format.
    </section>
    
###  <section id="merging-coe">3.3. Merging COE Files
The script can merge COE files from distinct photos for projects that need more than one image frame or channel. It reads the COE files for two photos, appending the second image's data to the first image's COE files. As a result, combined COE files with the picture data from the two sources are produced. To display numerous frames, you must complete this step.
    </section>
###  <section id="file-cleanup">3.4. File Cleanup
An intermediate and temporary file formed during processing is deleted by the cleanup function of the script, which helps to keep the workspace tidy. Files created during COE file creation and image conversion fall within this category. By deleting these files, clutter and possible confusion are avoided and only necessary outputs are kept. Three COE files are produced at the conclusion of the process: one for the red, blue, and green values of the pixels.The ideal length for them would be 240002 lines.
    </section>
At the end of this whole process, we get 3 COE files, one for red values, one for blue values and one for green values of the pixels.They should ideally be 240002 lines long. 
</section>

## <section id="verilog-code">4. Verilog Code Overview
### <section id="top-module">4.1. Top Module (top.v)
The Top Module unifies several components and coordinates the FPGA's overall functionality.Top module performs four primary functions.

<b>Clock Management</b>: By timing VGA signals, this secondary clock makes sure that the VGA display is synchronized correctly.

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

The pixel data is only provided when h_sync and v_sync are within the given parameters, which here are 800 for h_sync and 600 for v_sync, whereas all the other times, the output is "00".
    </section>
    
### <section id= "#memory-modules"> 4.3. Memory Modules
A dedicated memory block incorporated in the FPGA fabric is called a block RAM (BRAM). These devices offer rapid on-chip storage for a range of uses, including lookup tables, data buffering, caching, and coefficient storage. Because BRAMs may be easily customized in terms of size, width, and depth, designers can use them to best suit certain jobs. Dedicated memory modules are incorporated into the FPGA design to effectively store and retrieve color data utilized in VGA output.Every cycle of pixel updating involves a sequential access to these ROM modules. Based on the current pixel coordinates, the FPGA retrieves the relevant color values from these modules when the VGA output needs to be refreshed. This ensures that the correct RGB values are provided to the VGA interface, allowing for accurate color representation on the screen. The number of BRAM tiles utilised are 90% i.e. 45/50, hence maximum usage of the BRAM is done.
    </section>
</section>

## <section id= "#conclusion"> 5.Conclusion
FPGA technology's adaptability and strength in producing bespoke hardware solutions have been effectively showcased by the building of a custom video card utilizing the Arty A7 35T FPGA board. We developed a strong system that can handle picture data effectively by integrating specially designed modules for clock control, synchronization signal production, and memory management. The procedure was made simpler by using Python for COE file generation and picture preprocessing, which made it possible to convert and load image data into the FPGA with ease.Here are some pictures and GIFs that we were able to show off using the video card.

<image align ="center" src = "https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/fcc8ff8beb741ebb41a7290043ae588f4ab5669c/assets/Nyaan_Cat.gif" height="600px" width = "1000px"/>

<image align ="center" src = "https://github.com/MrCheese260/Eklavya-Video-Card-Project/blob/fcc8ff8beb741ebb41a7290043ae588f4ab5669c/assets/Lion_Image.jpg" height="600px" width = "1000px"/>

This project has not only deepened our understanding of FPGA design and video processing but also highlighted the importance of a systematic approach to hardware development. The knowledge and skills gained from this project will serve as a solid foundation for future endeavors in digital design and FPGA-based development.
</section>

##  <section id= "#acknowledgement"> 6.Acknowledgement

This project was brought to life thanks to the Eklavya mentorship program by SRA-VJTI, where continuous support and encouragement were provided at every stage. The availability of FPGA boards from SRA was essential, enabling us to explore and implement our ideas practically.

Our mentors, Saish Karole and Atharv Patil, were crucial in guiding us through the project. Their expertise and practical advice helped us overcome challenges and achieve our objectives efficiently.

The SRA-VJTI community provided a solid foundation for learning and problem-solving. Regular meetings and discussions with our mentors kept us on track and addressed any issues promptly. Additionally, we utilized Ben Eater's video as a valuable reference to guide our design and implementation.
