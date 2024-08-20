`timescale 1ns / 1ps

module hex_loader(
    input clk_fast,                // High-speed clock input for transferring data from 1D to 2D arrays
    input clk,                     // Slower clock input for processing and outputting RGB values
    input [9:0] reset_count_rgb,   // Vertical sync counter from the top module
    input [10:0] count_rgb,       // Horizontal sync counter from the top module
    output reg [1:0] red_1,        // Red color output
    output reg [1:0] green_1,      // Green color output
    output reg [1:0] blue_1        // Blue color output
    );
    
    reg [16:0] k;                  // Index for iterating through the 1D arrays

    // 1D arrays to store red, green, and blue pixel values
    reg [1:0] red [0:119999]; 
    reg [1:0] blue [0:119999]; 
    reg [1:0] green [0:119999];

    //Initialize counters and load binary files into 1-D arrays 
    initial begin
        $readmemb("C:/Users/sarve/output_g.txt", green);
        $readmemb("C:/Users/sarve/output_b.txt", blue);
        $readmemb("C:/Users/sarve/output_r.txt", red);
        k = 16'd0;                 
    end
    
    // Generate the output color values based on pixel coordinates and interpolation
    always @(posedge clk) begin
        // Output values only when the counters are within the display area (e.g., 800x600)
        if (count_rgb < 11'd800 && reset_count_rgb < 10'd600) begin
            k = ((count_rgb/2) + (reset_count_rgb/2)*400);
            red_1 <= red [k];
            green_1 <= green [k];
            blue_1 <= blue [k];
        end else begin
            // Set output to black (0) if the pixel is outside the display area
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
    end
endmodule
