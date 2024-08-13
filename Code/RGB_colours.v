`timescale 1ns / 1ps


module RGB_colours(
    input clk,
    input [9:0] reset_count_rgb,
    input [10:0] count_rgb,
    output reg [7:0] red_1,
    output reg [7:0] green_1,
    output reg [7:0] blue_1
    );
    reg [9:0] i;
    reg [9:0] j;
    //Slice1
    reg [7:0] red1 [0:199][0:149];
    reg [7:0] green1 [0:199][0:149];
    reg [7:0] blue1 [0:199][0:149];
    //Slice2
//    reg [7:0] red2 [0:199][0:149];
//    reg [7:0] green2 [0:199][0:149];
//    reg [7:0] blue2 [0:199][0:149];
//    //Slice3
//    reg [7:0] red3 [0:199][0:149];
//    reg [7:0] green3 [0:199][0:149];
//    reg [7:0] blue3 [0:199][0:149];
//    //Slice4
//    reg [7:0] red4 [0:199][0:149];
//    reg [7:0] green4 [0:199][0:149];
//    reg [7:0] blue4 [0:199][0:149];
    
    
    initial begin
   //Slice1
        $readmemh("C:/Vivado/h_sync/new_output_G.hex", green1);
        $readmemh("C:/Vivado/h_sync/new_output_B.hex", blue1);
        $readmemh("C:/Vivado/h_sync/new_output_R.hex", red1);
   //Slice2
//        $readmemh("C:/Vivado/h_sync/output_hex_array_top_2_G.hex", green2);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_top_1_B.hex", blue2);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_top_1_R.hex", red2);
//   //Slice3
//        $readmemh("C:/Vivado/h_sync/output_hex_array_middle_G.hex", green3);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_middle_B.hex", blue3);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_middle_R.hex", red3);
//   //Slice4
//        $readmemh("C:/Vivado/h_sync/output_hex_array_bottom_G.hex", green4);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_bottom_B.hex", blue4);
//        $readmemh("C:/Vivado/h_sync/output_hex_array_bottom_R.hex", red4);

        i = 0;
        j = 0;
        end
        always @(posedge clk) begin
        if (count_rgb < 200 && reset_count_rgb < 150) begin //Slice1
            red_1 <= red1[i][j];
            green_1 <= green1[i][j];
            blue_1 <= blue1[i][j];
            i = i + 1;
        end
        
        else if (count_rgb == 1040) begin
            j = j + 1;
            i = 10'd0;
        end
        else begin
            red_1 <= 8'd0;
            green_1 <= 8'd0;
            blue_1 <= 8'd0;
        end
      end
endmodule