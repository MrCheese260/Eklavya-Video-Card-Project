`timescale 1ns / 1ps

module hex_loader(
    input clk_fast,                // High-speed clock input for transferring data from 1D to 2D arrays
    input clk,                     // Slower clock input for processing and outputting RGB values
    input [9:0] reset_count_rgb,   // Vertical sync counter from the top module
    input [10:11] count_rgb,       // Horizontal sync counter from the top module
    output reg [1:0] red_1,        // Red color output
    output reg [1:0] green_1,      // Green color output
    output reg [1:0] blue_1        // Blue color output
    );
    
    reg [16:0] k;                  // Index for iterating through the 1D arrays
    reg [8:0] i, j;                // Indices for iterating through the 2D arrays

    // 1D arrays to store red, green, and blue pixel values
    reg [1:0] red_i [0:119999]; 
    reg [1:0] blue_i [0:119999]; 
    reg [1:0] green_i [0:119999];

    // 2D arrays used for storing interpolated pixel values
    reg [1:0] red [0:399][0:299];  
    reg [1:0] blue [0:399][0:299];  
    reg [1:0] green [0:399][0:299];  

    //Initialize counters and load binary files into 1-D arrays 
    initial begin
        $readmemb("C:/Users/sarve/output_g.txt", green);
        $readmemb("C:/Users/sarve/output_b.txt", blue);
        $readmemb("C:/Users/sarve/output_r.txt", red);
        k = 16'd0;                
        i = 8'd0;                 
        j = 8'd0;                 
    end
    
    // Transfer contents of the 1D arrays into the 2D arrays
    always @(posedge clk_fast) begin
        if (i < 9'd400 && j < 9'd300) begin
            // Assign values from 1D array to corresponding 2D array positions
            red[i][j] <= red_i[k];
            green[i][j] <= green_i[k];
            blue[i][j] <= blue_i[k];
            k = k + 16'd1;         // Increment 1D array index
            i = i + 9'd1;          // Increment row index
        end else begin
            i = 9'd0;              // Reset row index when it exceeds 400
            j = j + 9'd1;          // Increment column index
        end  
    end
    
    // Generate the output color values based on pixel coordinates and interpolation
    always @(posedge clk) begin
        // Output values only when the counters are within the display area (e.g., 800x600)
        if (count_rgb < 11'd800 && reset_count_rgb < 10'd600) begin
            // Check if both coordinates are even
            if(count_rgb % 2 == 0 && reset_count_rgb % 2 == 0) begin
                // Directly use the value from the 2D array
                red_1 <= red[(count_rgb / 2)][(reset_count_rgb / 2)];
                green_1 <= green[(count_rgb / 2)][(reset_count_rgb / 2)];
                blue_1 <= blue[(count_rgb / 2)][(reset_count_rgb / 2)];
            end
            // If horizontal coordinate is odd and vertical coordinate is even
            else if (count_rgb % 2 == 1 && reset_count_rgb % 2 == 0) begin
                // Use the value from the nearest even coordinate on the left
                red_1 <= red[((count_rgb - 1) / 2)][(reset_count_rgb / 2)];
                green_1 <= green[((count_rgb - 1) / 2)][(reset_count_rgb / 2)];
                blue_1 <= blue[((count_rgb - 1) / 2)][(reset_count_rgb / 2)];
            end
            // If horizontal coordinate is even and vertical coordinate is odd
            else if (count_rgb % 2 == 0 && reset_count_rgb % 2 == 1) begin
                // Use the value from the nearest even coordinate above
                red_1 <= red[(count_rgb / 2)][((reset_count_rgb - 1) / 2)];
                green_1 <= green[(count_rgb / 2)][((reset_count_rgb - 1) / 2)];
                blue_1 <= blue[(count_rgb / 2)][((reset_count_rgb - 1) / 2)];
            end
            // If both coordinates are odd
            else if (count_rgb % 2 == 1 && reset_count_rgb % 2 == 1) begin
                // Use the value from the nearest pixel with both even coordinates
                red_1 <= red[((count_rgb - 1) / 2)][((reset_count_rgb - 1) / 2)];
                green_1 <= green[((count_rgb - 1) / 2)][((reset_count_rgb - 1) / 2)];
                blue_1 <= blue[((count_rgb - 1) / 2)][((reset_count_rgb - 1) / 2)];
            end
        end else begin
            // Set output to black (0) if the pixel is outside the display area
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
    end
endmodule
