`timescale 1ns / 1ps

module hex_loader(
    input clk_fast,                // High-speed clock input for transferring data from 1D to 2D arrays
    input clk,                     // Slower clock input for processing and outputting RGB values
    input [9:0] reset_count_rgb,   // Vertical sync counter from the top module
    input [10:0] count_rgb,       // Horizontal sync counter from the top module
    output reg [2:0] red_1,        // Red color output
    output reg [2:0] green_1,      // Green color output
    output reg [2:0] blue_1        // Blue color output
    );
    
    reg [16:0] k;                  // Index for iterating through the 1D arrays

    // 1D arrays to store red, green, and blue pixel values
    wire [2:0] red ;
    wire [2:0] blue ;
    wire [2:0] green ;
    
    blue_ram u_blue_ram (
       .clka(clk_fast),
       .addra(k),
       .douta(blue)
    );
    
    green_ram u_green_ram (
       .clka(clk_fast),
       .addra(k),
       .douta(green)
    );
    
    
    red_ram u_red_ram (
       .clka(clk_fast),
       .addra(k),
       .douta(red)
    );
    
    // Generate the output color values based on pixel coordinates and interpolation
    always @(posedge clk) begin
        // Output values only when the counters are within the display area (e.g., 800x600)
        if (count_rgb < 11'd800 && reset_count_rgb < 10'd600) begin
            k = ((count_rgb/2) + ((reset_count_rgb/2)*400));
            red_1 <= red;
            green_1 <= green;
            blue_1 <= blue;
        end else begin
            // Set output to black (0) if the pixel is outside the display area
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
    end
endmodule