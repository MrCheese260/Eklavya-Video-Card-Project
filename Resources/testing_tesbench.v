`timescale 1fs / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2024 20:20:29
// Design Name: 
// Module Name: testing_tesbench
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


module testing_tesbench();
reg clk;
wire [1:0] red_port;
wire [1:0] green_port;
wire [1:0] blue_port;
wire h_sync_in;
wire [10:0] count;
wire v_sync_in;
wire [9:0] reset_count;

 tester uut (
    .count(count),
    .red_port(red_port),
    .green_port(green_port),
    .blue_port(blue_port),
    .v_sync_in(v_sync_in),
    .reset_count(reset_count),
    .clk(clk),
    .h_sync_in(h_sync_in)
);
  initial begin
    clk = 0; 
  end 
  always begin 
    #5 clk = ~clk;
    if (reset_count == 666)
        $finish;
  end
endmodule
