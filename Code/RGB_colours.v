`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2024 10:25:26
// Design Name: 
// Module Name: RGB_colours
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RGB_colours(
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [7:0] red2,
    output reg [7:0] green2,
    output reg [7:0] blue2
    );
    reg [9:0] i;
    reg [9:0] j;
    reg [7:0] red1 [0:799][0:599];
    reg [7:0] green1 [0:799][0:599];
    reg [7:0] blue1 [0:799][0:599];
    
    initial begin
        $readmemh("C:/Users/sarve/Downloads/output_hex_array_G.hex", green1);
        $readmemh("C:/Users/sarve/Downloads/output_hex_array_B.hex", blue1);
        $readmemh("C:/Users/sarve/Downloads/output_hex_array_R.hex", red1);
        i = 0;
        j = 0;
        end
        always @(posedge clk) begin
        if (count_rgb < 800 && reset_count_rgb < 600) begin
            red2 <= red1[i][j];
            green2 <= green1[i][j];
            blue2 <= blue1[i][j];
            i = i + 1;
        end
        else if (count_rgb == 1040) begin
            j = j + 1;
            i = 10'd0;
        end
        else begin
            red2 <= 8'd0;
            green2 <= 8'd0;
            blue2 <= 8'd0;
        end
      end
endmodule
