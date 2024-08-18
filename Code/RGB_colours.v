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
    reg [8:0] i,j;
    // 1-D array to store red, green and blue values
    reg [1:0] red_i [0:119999]; 
    reg [1:0] blue_i [0:119999]; 
    reg [1:0] green_i [0:119999];
    // 2-D array used for interpolation
    reg [1:0] red [0:399][0:299];  
    reg [1:0] blue [0:399][0:299];  
    reg [1:0] green [0:399][0:299];  
    initial begin
        // read binary file into 1-D array
        $readmemb("C:/Users/sarve/output_g.txt", green);
        $readmemb("C:/Users/sarve/output_b.txt", blue);
        $readmemb("C:/Users/sarve/output_r.txt", red);
        k = 16'd0;
        i = 8'd0;
        j = 8'd0;
    end
    // trasnfer contents of 1-D array to 2-D array
    always @(posedge clk_fast) begin
        if (i < 9'd400 && j < 9'd300) begin
            red[i][j] <= red_i[k];
            green[i][j] <= green_i[k];
            blue[i][j] <= blue_i[k];
            k = k + 16'd1;
            i = i + 9'd1;
         end
         else begin
            i = 9'd0; 
            j = j + 9'd1;
         end  
    end
    always @(posedge clk) begin
        // output only when count and reset_count are between 800 an 600
        if (count_rgb < 11'd800 && reset_count_rgb < 10'd600) begin
            // If the pixel has both even coordinates [eg: (0,0)] fill in the values directly from 2-D array
            if(count_rgb%2==0 && reset_count_rgb%2 == 0) begin
                red_1 <= red[(count_rgb/2)][(reset_count_rgb/2)];
                green_1 <= green[(count_rgb/2)][(reset_count_rgb/2)];
                blue_1 <= blue[(count_rgb/2)][(reset_count_rgb/2)];
            end
             // Else fill in the values from the nearest pxiel having both both even coordinates
            else if (count_rgb%2 == 1 && reset_count_rgb%2 ==0) begin
                red_1 <= red[((count_rgb - 1)/2)][(reset_count_rgb/2)];
                green_1 <= green[((count_rgb - 1)/2)][(reset_count_rgb/2)];
                blue_1 <= blue[((count_rgb - 1)/2)][(reset_count_rgb/2)];
            end
            else if (count_rgb%2 == 0 && reset_count_rgb%2 == 1) begin
                red_1 <= red[(count_rgb/2)][((reset_count_rgb - 1)/2)];
                green_1 <= green[(count_rgb/2)][((reset_count_rgb - 1)/2)];
                blue_1 <= blue[(count_rgb/2)][((reset_count_rgb - 1)/2)];
            end
             else if (count_rgb%2 == 1 && reset_count_rgb%2 == 1) begin
                red_1 <= red[((count_rgb - 1)/2)][((reset_count_rgb - 1)/2)];
                green_1 <= green[((count_rgb - 1)/2)][((reset_count_rgb - 1)/2)];
                blue_1 <= blue[((count_rgb - 1)/2)][((reset_count_rgb - 1)/2)];
             end
        end
        else begin
            red_1 <= 2'd0;
            green_1 <= 2'd0;
            blue_1 <= 2'd0;
        end
    end
endmodule
