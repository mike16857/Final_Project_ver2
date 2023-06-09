`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 05:30:49
// Design Name: 
// Module Name: door
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


module door(
	input            clk,
	input      [1:0] direction,
	input      [4:0] state,
	input            door_open_sw,
	input            door_close_sw,
	output reg       door_state = 0
    );
	
	parameter max=100000000; //2秒
	reg [30:0] n;
	
	always @(posedge clk) begin
		if (direction == 2'b00) begin
			if(door_open_sw && door_close_sw)	//???sw同?打? ????
				door_state <= 1;
			else if(door_open_sw)	//??sw打?
				door_state <= 1;
			else if(door_close_sw)	//??sw打?
				door_state <= 0;
		end
		
		if (n == max) begin
			n <= 0;
			case(state)
                5'b00000://??求
                    begin
                        if(door_open_sw == 0)
                            door_state <= 0;
                    end
                5'b00001://?求1 ?前1
                    begin
                        door_state <= 1;
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
                        door_state <= 1;
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
                        door_state <= 1;
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
                        door_state <= 1;
                    end
			endcase
		end
		else n <= n + 1;
	end
	
	
	
endmodule
