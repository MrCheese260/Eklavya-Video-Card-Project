`timescale 10fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2024 16:11:23
// Design Name: 
// Module Name: test
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


module test(

    );
reg clk;
wire h_sync_in;
wire v_sync_in;
wire [9:0] reset_count;
h_sync uut (
.v_sync_in(v_sync_in),
.reset_count(reset_count),
.clk(clk),
.h_sync_in(h_sync_in)
);
  initial begin
    clk = 0; 
  end 
  always begin 
    #10 clk = ~clk;
    if (reset_count == 666)
        $finish;
  end
endmodule
