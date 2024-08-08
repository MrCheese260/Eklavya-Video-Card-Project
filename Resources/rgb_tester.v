`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2024 19:54:23
// Design Name: 
// Module Name: rgb_tester
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


module rgb_tester(
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [7:0] red2,
    output reg [7:0] green2,
    output reg [7:0] blue2
    );
    reg [9:0] i;
    reg [9:0] j;
    reg [7:0] red1 [0:399][0:299];
    reg [7:0] green1 [0:399][0:299];
    reg [7:0] blue1 [0:399][0:299];

    initial begin
        $readmemh("C:/Users/sarve/blue_values.hex", green1);
        $readmemh("C:/Users/sarve/red_values.hex", blue1);
        $readmemh("C:/Users/sarve/green_values.hex", red1);
        i = 0;
        j = 0;
        end
        always @(posedge clk) begin
        if (count_rgb < 400 && reset_count_rgb < 300) begin
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
