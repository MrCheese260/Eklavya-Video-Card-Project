`timescale 1ns / 1ps


module rgb_tester(
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [7:0] red_1,
    output reg [7:0] green_1,
    output reg [7:0] blue_1
    );
    reg [14:0] k;
    reg [7:0] red1 [0:29999];
    reg [7:0] green1 [0:29999];
    reg [7:0] blue1 [0:29999];
    
    initial begin
        $readmemh("C:/Users/sarve/new_output_g.hex", green1);
        $readmemh("C:/Users/sarve/new_output_b.hex", blue1);
        $readmemh("C:/Users/sarve/new_output_r.hex", red1);
        k = 15'd0;
        end
        always @(posedge clk) begin
        if (count_rgb < 11'd200 && reset_count_rgb < 10'd150) begin //Slice1
            red_1 <= red1[k];
            green_1 <= green1[k];
            blue_1 <= blue1[k];
            k <= k + 15'd1;
        end
        else begin
            red_1 <= 8'd0;
            green_1 <= 8'd0;
            blue_1 <= 8'd0;
        end
      end
endmodule
