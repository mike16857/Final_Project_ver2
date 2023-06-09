`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 03:59:33
// Design Name: 
// Module Name: ELEV_in_btn
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


module ELEV_in_btn(
	input            clk,
//	input            clk_2sec,
	input            press1,
	input            press2,
	input            press3,
	input            press4,
	input      [4:0] state,
	output reg       press_in1 = 0,
	output reg       press_in2 = 0,
	output reg       press_in3 = 0,
	output reg       press_in4 = 0
    );
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	always @(posedge clk) begin
		if (press1)
			press_in1 <= ~press_in1;
		if (press2)
			press_in2 <= ~press_in2;
		if (press3)
			press_in3 <= ~press_in3;
		if (press4)
			press_in4 <= ~press_in4;
		
		
		if (n == max) begin
			n <= 0;
			case(state)
                5'b00000://??求
                    begin
    
                    end
                5'b00001://?求1 ?前1
                    begin
                    press_in1 <= 0;
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
                    press_in2 <= 0;
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
                    press_in3 <= 0;
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
                    press_in4 <= 0;
                    end
            endcase
		end
		else n <= n + 1;
	end
	
	
endmodule
