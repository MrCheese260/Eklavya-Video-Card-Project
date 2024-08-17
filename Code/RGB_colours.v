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
    reg [18:0] k;
    reg [1:0] red [0:479999];
    reg [1:0] blue [0:479999];
    reg [1:0] green [0:479999];
    initial begin
        $readmemb("C:/Vivado/h_sync/output_g.txt", green);
        $readmemb("C:/Vivado/h_sync/output_b.txt", blue);
        $readmemb("C:/Vivado/h_sync/output_r.txt", red);
        k = 16'd0;
        end
        always @(posedge clk) begin
        if (count_rgb < 11'd800 && reset_count_rgb < 11'd600) begin
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