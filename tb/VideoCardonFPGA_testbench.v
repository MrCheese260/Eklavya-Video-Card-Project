`timescale 1fs / 1fs  // Define time unit (1 femtosecond) and time precision (1 femtosecond)

module tb();

  // Declare input and output signals
  reg clk;  // Clock signal for the FPGA
  wire h_sync_in;  // Horizontal synchronization signal
  wire frame_switch;  // Signal to switch between frames in case of multiple frames
  wire [10:0] count;  // Pixel counter, typically used to keep track of the horizontal position of pixels
  wire v_sync_in;  // Vertical synchronization signal
  wire [9:0] reset_count;  // Counter used for resetting the pixel position or managing frame updates
  wire [1:0] red2, green2, blue2;  // 2-bit color channels for red, green, and blue

  // Instantiate the top module, which integrates various components of the FPGA design
  top uut (
    .frame_switch(frame_switch),  // Connect frame_switch signal to the top module
    .red_out(red2),  // Connect 2-bit red channel output to the top module
    .blue_out(blue2),  // Connect 2-bit blue channel output to the top module
    .green_out(green2),  // Connect 2-bit green channel output to the top module
    .count(count),  // Connect pixel counter to the top module
    .v_sync_in(v_sync_in),  // Connect vertical synchronization signal to the top module
    .reset_count(reset_count),  // Connect reset counter to the top module
    .clk(clk),  // Connect clock signal to the top module
    .h_sync_in(h_sync_in)  // Connect horizontal synchronization signal to the top module
  );

  // Initialize the clock signal to 0
  initial begin
    clk = 0; 
  end 

  // Generate a clock signal by toggling the clk value every 5 femtoseconds
  always begin 
    #5 clk = ~clk;

    // Terminate simulation when the reset_count reaches 666
    // This condition allows for a controlled end to the simulation, preventing it from running indefinitely
    if (reset_count == 666)
        $finish;
  end
endmodule

