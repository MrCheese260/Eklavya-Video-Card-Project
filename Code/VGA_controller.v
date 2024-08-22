`timescale 1us/1ps
module top(
    input clk,
    output reg h_sync_in,
    output reg v_sync_in,
    output reg [9:0] reset_count,
    output reg [10:0] count,
    output wire [2:0] red_out,
    output wire [2:0] green_out,
    output wire [2:0] blue_out
    );
  reg new_clk;
    initial begin
        reset_count <= 0;
        count <= 0;
        h_sync_in <= 1;
        v_sync_in <= 1;
        new_clk <= 0;
    end 
    
    always @(posedge clk) begin
        new_clk <= ~new_clk;
     end
    
          
    always @(posedge new_clk) begin
       count <= count + 1;
        case (count)
        800: h_sync_in <= 1;
        856: h_sync_in <= 0;
        976: h_sync_in <= 1;
        1040: begin
                count <= 0;
                reset_count <= reset_count + 1;
                 case(reset_count)
                        634: v_sync_in <= 0;                           
                        643: v_sync_in <= 1;
                        666:begin 
                             reset_count <= 0;
                            end
                  endcase
              end    
        endcase
          
    end
    
   hex_loader x1 (
        .clk_fast(clk),
        .clk(new_clk),
        .reset_count_rgb(reset_count),
        .count_rgb(count),
        .red_1(red_out),
        .green_1(green_out),
        .blue_1(blue_out)
   );
   endmodule
