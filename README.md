# Eklavya-Video-Card-Project
## Introduction
This project focuses on the design and implementation of a video card using FPGA technology, capable of displaying images in 800x600 resolution with up to 64 colors through an analog VGA interface. The original image provided to the FPGA for displaying must be in <b>400x300</b> resolution. The input images provided to the video card are originally 400x300 in resolution since the video card supports only that big of a resolution, but we interpolate the images using nearest neighbour interpolation to 800x600 resolution.The images are converted into 2-bit COE files, which are stored in the 1800 Kbit memory present on the FPGA.
<hr>

## Converting images into COE files using the makefile
A make file consists of all the dependancies needed to run a code to be executed with proper commands to create target for dependancies.
Steps to run the make file:
1. On your terminal, Navigate to the Directory Containing the Makefile: Use the cd command to go to the folder where your Makefile is located
cd /path_to_your_Makefile
2. Run the command “make” in your directory
3. To clean all the file run the command “make clean”
4. Demo input images has been added to run default to the COEfile_generation.py. To use the code to display user defined images, uncomment 
 the input function and comment out the default input given below the input function 
## Steps to Flash code on FPGA from Vivado
1. Launch Vivado and open your project.
2. Click on "Generate Bitstream" in the Flow Navigator on the left.
3. We can select between 2 different modes to flash on the FPGA
   <b>JTAG Mode</b> allows for direct programming and debugging of the FPGA through a dedicated JTAG interface, providing real-time control and     
   configuration.

  <b>Quad SPI (QSPI) Mode</b> allows the FPGA to store its configuration in a Quad SPI flash memory, offering faster data transfer rates 
  compared to standard SPI. This mode is ideal for applications requiring rapid configuration loading, as the FPGA reads the configuration 
  data from the flash memory on power-up.
### Mode 1:Steps for Flashing via JTAG
1. After synthesizing and implementing your design, click on the "Program and Debug" section in the Vivado Flow Navigator on the left and Select "Open Hardware Manager" to initiate the connection with the FPGA.
2. In the Hardware Manager, click "Open Target" in the toolbar, then select "Auto Connect." Vivado will automatically detect your FPGA board.
3. Once connected, right-click on your device under "Hardware" and choose "Program Device."
4. Select the .bin file generated during the synthesis and implementation step.
5. Click "Program" to flash the design onto the FPGA.
### Mode 2:Steps for Flashing via QUAD SPI
1.After synthesizing and implementing your design, click on the "Program and Debug" section in the Vivado Flow Navigator on the left and Select "Open Hardware Manager" to initiate the connection with the FPGA.<br />

2.In the Hardware Manager, click "Open Target" in the toolbar, then select "Auto Connect." Vivado will automatically detect your FPGA board.<br />

3.Click Add Configuration Memory Device under the Tools tab. This opens a wizard to select the memory device.<br />

4.Select your Quad SPI flash device from the list and click OK.<br />

5.A window will appear with options to select the files to program. Choose the .bin file generated during bitstream generation. Click "Program" to start the process. This writes the bitstream into the Quad SPI flash memory.<br />

6.Once programming is complete, reset or power cycle your FPGA. It should load the configuration from the Quad SPI flash automatically and start running the design.<br />
<hr>

## Contributors
<ul>
  <li><a href = "https://github.com/MrCheese260">Sarvesh Ganu</a></li>
  <li><a href = "https://github.com/IamLegend509">Suchit Garad</a></li>
</ul>
<hr>

## Mentors
<ul>
  <li><a href = "https://github.com/NachtSpyder04">Saish Karole</a></li>
  <li><a href = "https://github.com/Atharv1035">Atharv Patil</a></li>
</ul>
<hr>

## Acknowledgements and Resources
<ul>
  <li><a href = "https://sravjti.in/">SRA VJTI Eklavya 2024</a></li>
  <li><a href = "https://hdlbits.01xz.net/wiki/Main_Page#">HDLBits</a></li>
  <li><a href = "https://www.chipverify.com/tutorials/verilog">ChipVerify</a></li>
  <li><a href = "https://youtu.be/l7rce6IQDWs?si=sDYVI5xStofbLPmd">"The world's worst Video Card?" by Ben Eater</a></li>
</ul>
