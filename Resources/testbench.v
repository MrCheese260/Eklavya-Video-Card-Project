
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
