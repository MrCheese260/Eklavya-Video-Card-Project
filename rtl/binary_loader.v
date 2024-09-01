`timescale 1fs / 1fs

module binary_loader(
    input clk_fast,                // High-speed clock input used for reading data from the BRAMs (1D arrays)
    input clk,                     // Slower clock input for processing and outputting RGB values
    input frame_switcher,          // Signal to switch between frames or parts of the image
    input [9:0] reset_count_rgb,   // Vertical sync counter from the top module, used to track the vertical position of the pixel
    input [10:0] count_rgb,        // Horizontal sync counter from the top module, used to track the horizontal position of the pixel
    output reg [1:0] red_1,        // 2-bit Red color output, representing the current pixel's red value
    output reg [1:0] green_1,      // 2-bit Green color output, representing the current pixel's green value
    output reg [1:0] blue_1        // 2-bit Blue color output, representing the current pixel's blue value
    );
    
    reg [17:0] k;                  // Index used for accessing the 1D arrays storing pixel values
    
    // Wires to hold the 2-bit pixel values fetched from the BRAMs
    wire [1:0] red ;
    wire [1:0] blue ;
    wire [1:0] green ;
    
    // Instantiation of the blue color BRAM module
    blue_ram u_blue_ram (
       .clka(clk_fast),           // Clock input for the BRAM
       .addra(k),                 // Address input for the BRAM, determines which pixel value to read
       .douta(blue)               // 2-bit output from the BRAM, gives the blue color value
    );
    
    // Instantiation of the green color BRAM module
    green_ram u_green_ram (
       .clka(clk_fast),           // Clock input for the BRAM
       .addra(k),                 // Address input for the BRAM, determines which pixel value to read
       .douta(green)              // 2-bit output from the BRAM, gives the green color value
    );
    
    // Instantiation of the red color BRAM module
    red_ram u_red_ram (
       .clka(clk_fast),           // Clock input for the BRAM
       .addra(k),                 // Address input for the BRAM, determines which pixel value to read
       .douta(red)                // 2-bit output from the BRAM, gives the red color value
    );
    
    // Always block triggered on the rising edge of the slower clock
    always @(posedge clk) begin
        // Only output color values when the pixel is within the display area (e.g., 800x600)
        if (count_rgb < 11'd800 && reset_count_rgb < 10'd600) begin
            // Assign the fetched 2-bit values to the output registers
            red_1 <= red;
            green_1 <= green;
            blue_1 <= blue;

            // Calculate the BRAM address based on pixel coordinates
            if(frame_switcher == 0) begin
                // For the first frame, calculate the address for the first part of the image
                k = ((count_rgb / 2) + ((reset_count_rgb / 2) * 400));
            end
            else if (frame_switcher == 1) begin
                // For the second frame, calculate the address with an offset
                k = (18'd119999 + ((count_rgb / 2) + ((reset_count_rgb / 2) * 400)));
            end
        end
        else begin
            // Set the output to black (all zeros) if the pixel is outside the display area
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
    end
endmodule
