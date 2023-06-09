`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 04:23:35
// Design Name: 
// Module Name: ELEV_out_btn
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


module ELEV_out_btn(
	input            clk,
	input            out1_up,
	input            out2_up,
	input            out2_down,
	input            out3_up,
	input            out3_down,
	input            out4_down,
//	input            led_out_test_sw,
	input      [4:0] state,
	input      [1:0] pointer,
	input      [3:0] request_total,
	input            press_in1,
	input            press_in2, 
	input            press_in3, 
	input            press_in4,
	output reg       press_out1_up = 0,
	output reg       press_out2_up = 0,
	output reg       press_out2_down = 0,
	output reg       press_out3_up = 0,
	output reg       press_out3_down = 0,
	output reg       press_out4_down = 0
    );
	
//	reg[5:0] last_state = 6'b000000;	//?左到右依次是1上，2上下，3上下，4下
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	always @(posedge clk) begin
		if (out1_up)
			press_out1_up <= ~press_out1_up;
		if (out2_up)
			press_out2_up <= ~press_out2_up;
		if (out2_down)
			press_out2_down <= ~press_out2_down;
		if (out3_up)
			press_out3_up <= ~press_out3_up;
		if (out3_down)
			press_out3_down <= ~press_out3_down;
		if (out4_down)
			press_out4_down <= ~press_out4_down;
			
//		last_state <= {out1_up_sw,out2_up_sw,out2_down_sw,out3_up_sw,out3_down_sw,out4_down_sw};
		
//		if(led_out_test_sw)
//		begin
//			press_out1_up <= 0;
//			press_out2_up <= 0;
//			press_out2_down <= 0;
//			press_out3_up <= 0;
//			press_out3_down <= 0;
//			press_out4_down <= 0;
//		end
		
		if(n == max) begin
			n <= 0;
			case(state)
                5'b00000://??求
                    begin
                        
                    end
                5'b00001://?求1 ?前1
                    begin
                        press_out1_up <= 0;
                    end
                5'b00010://?求1 ?前2
                    begin
                        
                    end
                5'b00011://?求1 ?前3
                    begin
                        
                    end
                5'b00100://?求1 ?前4
                    begin
                        
                    end
                5'b00101://?求2 ?前1
                    begin
                        
                    end
                5'b00110://?求2 ?前2
                    begin
                        if(press_out2_up == 0 && press_out2_down == 1 && (request_total == 4 ||
                            (press_out3_up == 0 && press_out3_down == 1  && request_total == 6)))
                            press_out2_down <= 0;
                        if(press_out2_up == 1 && press_out2_down == 0 && (request_total == 4 ||
                            (press_out3_up == 1 && press_out3_down == 0 && request_total == 6)))
                            press_out2_up <= 0;
                        if(pointer == 2'b10)
                            press_out2_down <= 0;
                        if(pointer == 2'b01)
                            press_out2_up <= 0;
                        if(pointer == 2'b00)
                        begin
                            press_out2_down <= 0;
                            press_out2_up <= 0;
                        end
                    end
                5'b00111://?求2 ?前3
                    begin
                        
                    end
                5'b01000://?求2 ?前4
                    begin
                        
                    end
                5'b01001://?求3 ?前1
                    begin
                        
                    end
                5'b01010://?求3 ?前2
                    begin
                        
                    end
                5'b01011://?求3 ?前3
                    begin
                        if(press_out3_up == 0 && press_out3_down == 1 && (request_total == 2 ||
                            (request_total == 6 && press_out2_up == 0 && press_out2_down == 1)))
                            press_out3_down <= 0;
                        if(press_out3_up == 1 && press_out3_down == 0 && (request_total == 2 ||
                            (request_total == 6 && press_out2_up == 1 && press_out2_down == 0)))
                            press_out3_up <= 0;
                        if(pointer == 2'b10)
                            press_out3_down <= 0;
                        if(pointer == 2'b01)
                            press_out3_up <= 0;
                        if(pointer == 2'b00)
                        begin
                            press_out3_down <= 0;
                            press_out3_up <= 0;
                        end
                    end
                5'b01100://?求3 ?前4
                    begin
                        
                    end
                5'b01101://?求4 ?前1
                    begin
                        
                    end
                5'b01110://?求4 ?前2
                    begin
                        
                    end
                5'b01111://?求4 ?前3
                    begin
                        
                    end
                5'b10000://?求4 ?前4
                    begin
                        press_out4_down <= 0;
                    end
			endcase
		end
		else n <= n + 1;
	end
	
endmodule
