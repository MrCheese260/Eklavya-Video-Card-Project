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


module tester(
    input clk,
    output reg h_sync_in,
    output reg v_sync_in,
    output reg [9:0] reset_count,
    output reg [10:0] count,
    output reg [1:0] red_port,
    output reg [1:0] green_port,
    output reg [1:0] blue_port
    );
    reg new_clk;
    reg [2:0] temp;
    wire [7:0] red, green, blue;
    initial begin
        temp <= 0;
        reset_count <= 0;
        count <= 0;
        h_sync_in <= 1;
        v_sync_in <= 1;
        new_clk <= 0;
    end 
    
    always @(posedge clk) begin
      temp <= temp + 2'd1;
       if(temp == 2'd3)begin
        new_clk <= ~new_clk;
        temp <= 0;
        end
     end
          
    always @(posedge new_clk) begin
       count <= count + 1;
        case (count)
        200: h_sync_in <= 1;
        214: h_sync_in <= 0;
        244: h_sync_in <= 1;
        260: begin
                count <= 0;
                reset_count <= reset_count + 1;
                 case(reset_count)
                        159: v_sync_in <= 0;                            
                        161: v_sync_in <= 1;
                        167: begin 
                            reset_count <= 0;
                            end
                  endcase
              end    
        endcase
          
    end
    
    rgb_tester x1 (
        .clk(new_clk),
        .reset_count_rgb(reset_count),
        .count_rgb(count),
        .red_1(red),
        .green_1(green),
        .blue_1(blue)
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
