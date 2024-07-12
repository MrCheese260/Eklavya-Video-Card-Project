`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2024 12:01:57
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input clk,
    output reg new_clk
    );
    reg [6:0] temp = 7'd0;
    reg temp1 = 0;
    always @ (posedge clk) begin
        temp <= temp + 1;
        if (temp1 == 0) begin
            new_clk <= 0;
            temp1 <= 1;
        end
        else if (temp == 7'd83) begin
            new_clk <= ~new_clk;
            temp <= 7'd0;
        end
     end
endmodule
