`timescale 1us/1ps
module top(
    input clk,                      // Input clock signal
    output reg h_sync_in,           // Horizontal sync signal output
    output reg v_sync_in,           // Vertical sync signal output
    output reg [9:0] reset_count,   // Reset counter for vertical sync
    output reg [10:0] count,        // Counter for horizontal sync
    output wire [1:0] red_out,      // Output for red color channel
    output wire [1:0] green_out,    // Output for green color channel
    output wire [1:0] blue_out      // Output for blue color channel
    );
  
  reg new_clk;                      
  // Initialize counters, clock, and horizontal/vertical sync signals
  initial begin
      reset_count <= 0;             // Initialize reset_count to 0
      count <= 0;                   // Initialize count to 0
      h_sync_in <= 1;               // Set initial horizontal sync signal
      v_sync_in <= 1;               // Set initial vertical sync signal
      new_clk <= 0;                 // Initialize new_clk to 0
  end 

  // Clock divider: Divide the input clock from 100MHz to 50MHz
  always @(posedge clk) begin
      new_clk <= ~new_clk;          // Toggle the new clock signal on every rising edge of the input clock
  end
  
  //block for timing the horizontal and vertical sync signals
  always @(posedge new_clk) begin
      count <= count + 1;           // Increment horizontal counter
      case (count)
          800: h_sync_in <= 1;      // Set h_sync_in high after 800 counts
          856: h_sync_in <= 0;      // Set h_sync_in low after 856 counts
          976: h_sync_in <= 1;      // Set h_sync_in high again after 976 counts
          1040: begin
                  count <= 0;       // Reset the horizontal counter after 1040 counts
              reset_count <= reset_count + 1;  // Increment the vertical counter (reset_count) when horizontal counter reaches end
                  case(reset_count)
                      634: v_sync_in <= 0;  // Set v_sync_in low after 634 counts
                      643: v_sync_in <= 1;  // Set v_sync_in high after 643 counts
                      666: begin 
                          reset_count <= 0;  // Reset the vertical counter (reset_count) after 666 counts i.e when 1 frame is completed
                      end
                  endcase
              end    
      endcase
  end
  
  // Instantiate hex_loader module, passing clock signals, counters, and RGB outputs
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
