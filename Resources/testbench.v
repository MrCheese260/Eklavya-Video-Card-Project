`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2024 12:26:26
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    reg clk;
    wire new_clk;
    
    clk_divider uut (
        .clk(clk),
        .new_clk(new_clk)
        );
     initial begin
        clk = 0;
        #1000000 $finish;
    end

    always #5 clk = ~clk;
endmodule
