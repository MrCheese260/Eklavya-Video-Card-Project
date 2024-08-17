`timescale 1ns / 1ps


module  hex_loader(
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [1:0] red_1,
    output reg [1:0] green_1,
    output reg [1:0] blue_1
    );
    reg [15:0] k;
    reg [1:0] red [0:119999];
    reg [1:0] blue [0:119999];
    reg [1:0] green [0:119999];
    initial begin
        $readmemh("C:/Users/sarve/new_output_g.hex", green);
        $readmemh("C:/Users/sarve/new_output_b.hex", blue);
        $readmemh("C:/Users/sarve/new_output_r.hex", red);
        k = 15'd0;
        end
        always @(posedge clk) begin
        if (count_rgb < 11'd400 && reset_count_rgb < 10'd300) begin
            red_1 <= red[k];
            green_1 <= green[k];
            blue_1 <= blue[k];
            k <= k + 15'd1;
        end
        else begin
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
      end
endmodule
