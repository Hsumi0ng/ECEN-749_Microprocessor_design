/********************************************************************
 *
 * Andrew Douglass
 * August 23, 2018
 * jackpot_tb.v
 *
 *******************************************************************/

`timescale 1ns / 1ps

// ENSURE THE FILE NAME BELOW MATCHES YOURS
//`include "jackpot.v"

module jackpot_tb;

// Inputs to the DUT
reg clk;
reg rst;
reg [3:0] switches;
// Output from the DUT
wire [3:0] leds;

// Init the DUT by connecting the ports
jackpot jkpot01 (
  .clock(clk),
  .reset(rst),
  .SWITCHES(switches),
  .LEDS(leds)
);

initial begin
  // Print the counter activity to the console
  $monitor("time=%d, rst=%d, switches=%b, leds=%b", $time, rst, switches, leds);

  $dumpfile("JackpotWave.vcd");   // Output the signals to the waveform file
  $dumpvars(0, jackpot_tb);       // Dump signals in the top module

  // Default starting value for all input signals
  clk = 1'b0;
  rst = 1'b1;
  switches = 4'b0000;

  // Exercise the inputs to test the module
  #50;
  rst = 1'b0;
  #100;
  @(posedge leds[1]);
  switches = 4'b0010;
  #50;
  rst = 1'b1;
  #50;
  rst = 1'b0;
  #80;
  @(posedge leds[2]);
  switches = 4'b1000;
  #50;
  $finish;

end

// Generate a 50% duty cycle clock with a period of 8ns.
// This is a 125MHz clock
always begin
  #4 clk <= ~clk;
end

endmodule
