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
    reg clk_div;
    reg [31:0] cnt;
    parameter frequency = 10;//6250000 
    reg [3:0] LEDS_r,SWITCHES_r;
    wire [3:0] detect;
    wire hold;
    //Frequency_division
    always@(posedge clock or posedge reset) begin
        if(reset) begin
            cnt <= 0;
            clk_div <= 0;
        end
        else begin
            if(cnt == frequency-1) begin
                clk_div <=~clk_div;
                cnt <= 0;
            end
            else cnt <= cnt+1;
        end
    end
    
    always@(posedge clk_div or posedge reset) begin
       if(reset)begin
            SWITCHES_r <= 0;
       end
       else begin
            SWITCHES_r  <= SWITCHES;
       end
    end
   assign detect = SWITCHES & ~SWITCHES_r;
        
   always@(posedge clk_div or posedge reset)begin
        if(reset) begin
            LEDS_r <= 4'b0001;
        end
        else begin
            if(hold) LEDS_r <= 4'b1111;
            else begin
                if(LEDS_r == 4'b1000) LEDS_r = 4'b0001; 
                else LEDS_r <= LEDS_r <<1 ;
            end  
        end
    end
    assign LEDS = LEDS_r == detect? 4'b1111:LEDS_r;
    assign hold = &LEDS;
endmodule
