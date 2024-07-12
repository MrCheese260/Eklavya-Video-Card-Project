`timescale 1ns / 100ps

module ClkDiv(
input clk,
output reg new_clk
    );
    reg [7:0] cnt = 0;
    initial begin
        new_clk <=0;
    end
    always @(posedge clk) begin
//To 625Khz
    if(cnt == 80) begin
        new_clk<=~new_clk;
        cnt<=0;
    end
    else begin
        cnt= cnt+1;
    end
    //To 434Khz
//    if(cnt == 115) begin
//        new_clk <= ~new_clk;
//        cnt<=0;
//    end
//    else begin
//        cnt= cnt+1;
//    end
    end
    
endmodule