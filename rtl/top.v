`timescale 1fs/1fs  // Define time unit (1 femtosecond) and time precision (1 femtosecond)

module top(
    input clk,  // Input clock signal for the FPGA
    output reg h_sync_in,  // Horizontal synchronization signal for VGA display
    output reg v_sync_in,  // Vertical synchronization signal for VGA display
    output reg [9:0] reset_count,  // Counter used for resetting or managing frame updates
    output reg [10:0] count,  // Pixel counter, tracks horizontal pixel position
    output wire [1:0] red_out,  // 2-bit output for the red color channel
    output wire [1:0] green_out,  // 2-bit output for the green color channel
    output wire [1:0] blue_out  // 2-bit output for the blue color channel
    );

  reg new_clk;  // Clock signal for controlling pixel updates (derived from the main clock)
  reg frame_switch;  // Signal to switch between frames (used in animations or double buffering)
  reg [4:0] temp;  // Temporary counter for managing frame switch intervals

  // Initial block to set default values for the registers
  initial begin
      reset_count <= 0;  
      count <= 0;  
      h_sync_in <= 1;  
      v_sync_in <= 1;  
      new_clk <= 0; 
      frame_switch <= 0;  
      temp <= 0; 
  end 
    
  // Clock divider: Toggle new_clk on each positive edge of the input clock
  // This generates a slower clock signal for pixel processing
  always @(posedge clk) begin
      new_clk <= ~new_clk;
  end

  // Main logic block to handle pixel counting and synchronization signals
  always @(posedge new_clk) begin
      count <= count + 1;  // Increment pixel counter on each new clock cycle

      // Manage horizontal synchronization signal based on pixel count
      case (count)
        800: h_sync_in <= 1;  // End of active video region, prepare for horizontal blanking
        856: h_sync_in <= 0;  // Horizontal sync pulse start
        976: h_sync_in <= 1;  // Horizontal sync pulse end
        1040: begin  // End of horizontal line, reset counter and update frame count
            count <= 0;  // Reset pixel counter to start a new line
            reset_count <= reset_count + 1;  // Increment line count

            // Manage vertical synchronization signal based on line count
            case(reset_count)
                634: v_sync_in <= 0;  // Vertical sync pulse start
                643: v_sync_in <= 1;  // Vertical sync pulse end
                666: begin  // End of frame (based on line count)
                    if(temp == 5'd10) begin  // After 10 frames, switch frame (used for animations)
                        frame_switch <= ~frame_switch;  // Toggle frame switch signal
                        temp <= 0;  // Reset temporary counter
                    end else begin
                        temp <= temp + 1;  // Increment temporary counter
                    end
                    reset_count <= 0;  // Reset line count for new frame
                end
            endcase
        end    
      endcase
  end
    
  // Instantiate binary_loader module to handle color output based on pixel and frame position
  binary_loader x1 (
        .clk_fast(clk),  // Fast clock signal to account for ROM latency
        .clk(new_clk),  // Slower clock for pixel processing
        .frame_switcher(frame_switch),  // Frame switch signal
        .reset_count_rgb(reset_count),  // Line count for color output
        .count_rgb(count),  // Pixel count for color output
        .red_1(red_out),  // Red color output
        .green_1(green_out),  // Green color output
        .blue_1(blue_out)  // Blue color output
  );
  
endmodule
