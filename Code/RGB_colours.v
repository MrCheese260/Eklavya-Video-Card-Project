`timescale 1ns / 1ps


module  hex_loader(
    input clk_fast,
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [1:0] red_1,
    output reg [1:0] green_1,
    output reg [1:0] blue_1
    );
    reg [16:0] k;
    reg [1:0] red [0:119999];
    reg [1:0] blue [0:119999];
    reg [1:0] green [0:119999];
    initial begin
        $readmemb("C:/Users/sarve/output_g.txt", green);
        $readmemb("C:/Users/sarve/output_b.txt", blue);
        $readmemb("C:/Users/sarve/output_r.txt", red);
        k = 16'd0;
        end
        always @(posedge clk) begin
        if (count_rgb < 11'd400 && reset_count_rgb < 10'd300) begin
            red_1 <= red[k];
            green_1 <= green[k];
            blue_1 <= blue[k];
            k <= k + 16'd1;
        end
        else begin
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
      end
endmodule
