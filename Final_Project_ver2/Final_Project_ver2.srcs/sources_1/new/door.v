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
	
	parameter max=100000000; //2��
	reg [30:0] n;
	
	always @(posedge clk) begin
		if (direction == 2'b00) begin
			if(door_open_sw && door_close_sw)	//???sw�P?��? ????
				door_state <= 1;
			else if(door_open_sw)	//??sw��?
				door_state <= 1;
			else if(door_close_sw)	//??sw��?
				door_state <= 0;
		end
		
		if (n == max) begin
			n <= 0;
			case(state)
                5'b00000://??�D
                    begin
                        if(door_open_sw == 0)
                            door_state <= 0;
                    end
                5'b00001://?�D1 ?�e1
                    begin
                        door_state <= 1;
                    end
                5'b00010://?�D1 ?�e2
                    begin
                        
                    end
                5'b00011://?�D1 ?�e3
                    begin
                        
                    end
                5'b00100://?�D1 ?�e4
                    begin
                        
                    end
                5'b00101://?�D2 ?�e1
                    begin
                        
                    end
                5'b00110://?�D2 ?�e2
                    begin
                        door_state <= 1;
                    end
                5'b00111://?�D2 ?�e3
                    begin
                        
                    end
                5'b01000://?�D2 ?�e4
                    begin
                        
                    end
                5'b01001://?�D3 ?�e1
                    begin
                        
                    end
                5'b01010://?�D3 ?�e2
                    begin
                        
                    end
                5'b01011://?�D3 ?�e3
                    begin
                        door_state <= 1;
                    end
                5'b01100://?�D3 ?�e4
                    begin
                        
                    end
                5'b01101://?�D4 ?�e1
                    begin
                        
                    end
                5'b01110://?�D4 ?�e2
                    begin
                        
                    end
                5'b01111://?�D4 ?�e3
                    begin
                        
                    end
                5'b10000://?�D4 ?�e4
                    begin
                        door_state <= 1;
                    end
			endcase
		end
		else n <= n + 1;
	end
	
	
	
endmodule
