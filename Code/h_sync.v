`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2024 12:45:23
// Design Name: 
// Module Name: h_sync
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


module h_sync(
    input clk,
    output reg h_sync_in,
    output reg v_sync_in,
    output reg [9:0] reset_count
    );
    reg [10:0] count;
    initial begin
        reset_count <= 0;
        count <= 0;
        h_sync_in <= 1;
        v_sync_in <= 1;
        end
    always @(posedge clk) begin
       count <= count + 1;
        case (count)
        800: h_sync_in <= 1;
        856: h_sync_in <= 0;
        976: h_sync_in <= 1;
        1040: begin 
                count <= 0;
                reset_count <= reset_count + 1;
              end    
        endcase
        if (reset_count >= 637 && reset_count < 644)
            v_sync_in <= 0;
        else
            v_sync_in <= 1;            
    end
    
endmodule
