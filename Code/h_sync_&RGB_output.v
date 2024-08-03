`timescale 1us/1ps
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
    input wire [7:0] red,
    input wire [7:0] green,
    input wire [7:0] blue,
    output reg h_sync_in,
    output reg v_sync_in,
    output reg [9:0] reset_count,
    output reg [10:0] count,
    output reg [1:0] red_port,
    output reg [1:0] green_port,
    output reg [1:0] blue_port
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
                        637: v_sync_in <= 0;                            
                        643: v_sync_in <= 1;  
                        666: reset_count <= 0; 
                  endcase
              end    
        endcase        
    end
    
    RGB_colours x1 (
        .clk(new_clk),
        .reset_count_rgb(reset_count),
        .count_rgb(count),
        .red2(red),
        .green2(green),
        .blue2(blue)
    );
    always @(posedge new_clk) begin
            if (red < 8'd33) begin
                red_port <= 2'b00;
            end
            else if (red > 8'd32 && red < 8'd129) begin
                red_port <= 2'b01; 
            end
            else if (red > 8'd128 && red < 8'd192) begin
                red_port <= 2'b10;
            end
            else begin
                red_port <= 2'b11;
            end
             
             
             
            if (green < 8'd33)begin
                green_port <= 2'b00;
            end
            else if (green > 8'd32 && green < 8'd129) begin
                green_port <= 2'b01; 
            end
            else if (green > 8'd128 && green < 8'd192)begin
                green_port <= 2'b10;
            end
            else begin
                green_port <= 2'b11;
            end
             
             
             
            if (blue < 8'd33)begin
                blue_port <= 2'b00;
            end
            else if (blue > 8'd32 && blue < 8'd129)begin
                blue_port <= 2'b01; 
            end
            else if (blue > 8'd128 && blue < 8'd192)begin
                 blue_port <= 2'b10;
            end
            else begin
                 blue_port <= 2'b11;
            end
    end
endmodule
