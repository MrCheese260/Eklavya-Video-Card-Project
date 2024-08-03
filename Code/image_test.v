`timescale 1ns / 1ps

module image_test(
    output reg [23:0] test_mem
    );
    reg [23:0] testing_123 [0:15];
    
    initial begin
        $readmemh("C:\Vivado\image_test\new_img_output.hex", testing_123);
    end
    always @* begin
     test_mem <= testing_123[1];   
     end
endmodule