/********************************************************************
 *
 * Andrew Douglass
 * August 21, 2018
 * counter_tb.v
 *
 *******************************************************************/

`timescale 1ns / 1ps

// ENSURE THE FILE NAME BELOW MATCHES YOURS
//`include "counter.v"

module counter_tb;

// Inputs to the DUT
reg clk;
reg rst;
reg up;
reg down;
// Output from the DUT
wire [3:0] leds;

// Init the DUT by connecting the ports
counter count01 (
  .CLOCK(clk),
  .RESET(rst),
  .UP(up),
  .DOWN(down),
  .LEDS(leds)
);

initial begin
  // Print the counter activity to the console
  $monitor("time=%d, rst=%d, up=%d, down=%d, leds=%b", $time, rst, up, down, leds);

  $dumpfile("CounterWave.vcd");   // Output the signals to the waveform file
  $dumpvars(0, counter_tb);       // Dump signals in the top module

  // Default starting value for all input signals
  clk = 1'b0;
  rst = 1'b1;
  up = 1'b0;
  down = 1'b0;

  // Exercise the inputs to test the module
  #50;
  rst = 1'b0;
  #50;
  up = 1'b1;
  #50;
  up = 1'b0;
  #30;
  down = 1'b1;
  #20;
  down = 1'b0;
  #20;
  rst = 1'b1;
  #20;
  rst = 1'b0;
  #20;
  up = 1'b1;
  #1200;
  up = 1'b0;
  #120;
  down = 1'b1;
  #120;
  down = 1'b0;
  #100
  $finish;

end

// Generate a 50% duty cycle clock with a period of 8ns.
// This is a 125MHz clock
always begin
  #4 clk <= ~clk;
end

endmodule
