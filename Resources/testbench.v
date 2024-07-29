`timescale 1ns / 100ps

module testbench(
    );
    reg clk;
    wire new_clk1;
    ClkDiv uut(
        .clk(clk),
        .new_clk(new_clk1)
        );
    initial begin
        clk = 0;
        #2147483647 $finish;
   end
   
   always #1 clk = ~clk;
endmodule