`timescale 1ns / 1ps

module counter(
         input CLOCK,RESET,UP,DOWN,
         output reg [3:0] LEDS
    ); 
    reg clk_div;
    reg [31:0] cnt;
    parameter frequency = 62500000 ;//125E6 - 1

   //Frequency_division
    always@(posedge CLOCK or posedge RESET) begin
        if(RESET) begin
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
    
    always@(posedge clk_div or posedge RESET) begin
        if(RESET) begin
            LEDS <= 4'd0;
         end
         else begin
            case({UP,DOWN})
                2'b00: LEDS <= LEDS;
                2'b01: LEDS <= LEDS - 1;
                2'b10: LEDS <= LEDS + 1;
                2'b11: LEDS <= LEDS;
            endcase
         end
     end
 
endmodule
