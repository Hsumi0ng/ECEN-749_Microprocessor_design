`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/21 19:28:35
// Design Name: 
// Module Name: jackpot
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


module jackpot(
    input clock, reset,
    input [3:0] SWITCHES,
    output [3:0] LEDS
    );
    reg [3:0] LEDS_r;
    wire hold;
    always@(posedge clock or posedge reset)begin
        if(reset) LEDS_r <= 4'b0001;
        else begin
            if(!hold) begin
                if(LEDS_r == 4'b1000) LEDS_r <= 4'b0001;
                else LEDS_r <= LEDS_r<<1;
            end
            else LEDS_r <= 4'b1111;
        end
    end
   assign  LEDS = (LEDS_r==SWITCHES)? 4'b1111:LEDS_r;
   assign hold = &LEDS;
endmodule
