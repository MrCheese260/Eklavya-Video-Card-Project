# Eklavya-Video-Card-Project

# Project Overview
This project aims to make a video card on fpga using Verilog HDL.

## Table of Contents

### Software used
Using Vivado software by AMD for the programming of FPGA (Diligent Arty A735).

###  Navigating through the repository
<p>
    1. Code folder: The code folder consists of: 
    
    a. ImageTest.py : Python script to generate a hex file (for three distinct colour channels i.e. Red, Green and blue) for the used image.
    
    b. h_sync.v : Main file responsible for the VideoCard to display the Screen of the resolution 800x600 @72Hz
    
    c. RGBColours.v : It is a module used in the main for the combination and usage of the hex files of the image used.
    
    d. image_test.v is a standalone test HDL file to check whether any type of image is being displayed.
</p>
<p>
    2. Testbench: It consists of simulation scripts to be run in Vivado.
</p>
<p>
    3. Resources: The resource folder consists of the test Image we have used and hex files for the respective colour channel.
</p>
