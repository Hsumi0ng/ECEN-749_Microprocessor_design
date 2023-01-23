`timescale 1ns / 1ps

module counter(
         input CLOCK,RESET,UP,DOWN,
         output reg [3:0] LEDS
    ); 
    reg clk_div;
    reg [1:0] UP_temp;
    reg [1:0] DOWN_temp;
    reg [21:0] cnt;
    reg [28:0] cnt2;
    reg [1:0] state,nstate;
    wire UP_press, UP_release, DOWN_press, DOWN_release;
    //wire UP_hold, DOWN_hold;
    wire press,rels;
    reg cnt_up,cnt_down;
    parameter IDLE = 2'b0, Press_f = 2'b1, Press = 2'd2, Release_f =2'd3;
    parameter frequency = 50 ;//125E6 - 1
    parameter filter = 10; // 25E6 - 1
    
   //Frequency_division
    always@(posedge CLOCK or posedge RESET) begin
        if(RESET) begin
            cnt2 <= 0;
            clk_div <= 0;
        end
        else begin
            if(cnt2 == frequency) begin
                clk_div <=~clk_div;
                cnt2 <= 0;
            end
            else cnt2 <= cnt2+1;
        end
    end
   // edge_detect
    always@(posedge CLOCK or posedge RESET) begin
        if(RESET) begin
            UP_temp <= 2'd0;
            DOWN_temp <= 2'd0;
        end
        else begin
            UP_temp <= {UP_temp[0],UP};
            DOWN_temp <= {DOWN_temp[0],DOWN};
        end
    end
    
    assign UP_press = UP_temp[0] & ~UP_temp[1];
    assign UP_release = ~UP_temp[0] & UP_temp[1];
    //assign UP_hold = UP_temp[0] & UP_temp[1];
    assign DOWN_press = DOWN_temp[0] & ~DOWN_temp[1];
    assign DOWN_release = ~DOWN_temp[0] & DOWN_temp[1];
    //assign DOWN_hold = DOWN_temp[0] & DOWN_temp[1];
    assign press = UP_press | DOWN_press;
    assign rels = UP_release | DOWN_release;
    
   // FSM
    always@(posedge CLOCK or posedge RESET) begin
        if(RESET) begin
            state <= IDLE;
            nstate <= IDLE;
         end
        else state <= nstate;
    end
      
    always@(posedge CLOCK or posedge RESET) begin
        if(RESET) begin
            cnt <= 22'b0;
            {cnt_up,cnt_down} <= 2'b00;
        end
        else begin
            case(nstate)
                IDLE: begin
                    if(press) nstate <= Press_f;
                    else nstate <= IDLE;
                end
                Press_f:begin
                    if(cnt>= filter) begin
                        nstate <= Press;
                        cnt <= 22'd0;
                    end
                    else if(rels) begin
                        nstate <= IDLE;
                        cnt <= 22'd0;
                    end
                    else begin
                        nstate <= Press_f;
                        cnt <= cnt + 1;
                    end
                end
                Press:begin
                    if(UP) begin
                        nstate <= Press;
                        cnt_up <= 1;
                    end
                    else if (DOWN) begin
                        nstate <= Press;
                        cnt_down <=1;
                    end
                    else begin
                        nstate <= Press;
                        cnt_up <= cnt_up;
                        cnt_down <= cnt_down;
                    end
                    if(rels) begin
                        nstate <= Release_f;
                        cnt <= 0;
                    end
                    else nstate <= Press;    
                end
                Release_f:begin
                    if(cnt>= filter) begin
                        nstate <= IDLE;
                        cnt <= 22'd0;
	                    {cnt_up,cnt_down} <= 2'b00;
                    end
                    else if(press) begin
                        nstate <= Press;
                        cnt <= 22'd0;
                    end
                    else begin
                        nstate <= Release_f;
                        cnt <= cnt + 1;
                    end
                end
             endcase
         end
      end          
 
    always@(posedge clk_div or posedge RESET) begin
        if(RESET) begin
            LEDS <= 4'd0;
         end
         else begin
            case({cnt_up,cnt_down})
                2'b00: LEDS <= LEDS;
                2'b01: LEDS <= LEDS -1;
                2'b10: LEDS <= LEDS +1;
                2'b11: LEDS <= LEDS;
            endcase
         end
     end
 
endmodule
