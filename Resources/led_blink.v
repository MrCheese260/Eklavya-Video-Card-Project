`timescale 10s / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2024 15:21:02
// Design Name: 
// Module Name: LedBlink32bit
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


module led_blink(
    input clk,
    output ledblink
);
    reg [31:0] counter; // 32-bit counter
  reg LED_status;     // LED status register

  initial begin
    counter <= 0;  
    LED_status <= 0;
  end

  always @ (posedge clk) begin
    counter <= counter + 1;  
    if (counter[24] == 1 ) begin 
      LED_status <= ~LED_status;
      counter <= 0;
    end
  end
assign ledblink = LED_status;

endmodule