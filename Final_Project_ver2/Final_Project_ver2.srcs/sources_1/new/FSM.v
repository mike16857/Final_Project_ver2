`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 04:55:13
// Design Name: 
// Module Name: FSM
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


module FSM(
	input            clk,
	input            press_in1,
    input            press_in2, 
    input            press_in3, 
    input            press_in4,
    input            press_out1_up,
    input            press_out2_up,
    input            press_out2_down,
    input            press_out3_up,
    input            press_out3_down,
    input            press_out4_down,
    input            door_state,
	output reg [1:0] now_floor = 2'b00,
	output reg [4:0] state = 5'b00000,
	output reg [1:0] direction = 2'b00,
	output reg [1:0] pointer = 2'b00,
	output reg [3:0] request_total = 4'b0000
    );
	
	parameter max=100000000; //2¬í
	reg [30:0] n;
	
	function [4:0] jump_state;
	   input [1:0] floor;
	   begin
           case(floor)
                2'b00: begin	    
                    case(now_floor)
                        2'b00:
                            begin
                            jump_state = 5'b00001;
                            end
                        2'b01:
                            begin
                            jump_state = 5'b00010;
                            end
                        2'b10:
                            begin
                            jump_state = 5'b00011;
                            end
                        2'b11:
                            begin
                            jump_state = 5'b00100;
                            end
                    endcase
                end
                2'b01: begin	    
                    case(now_floor)
                        2'b00:
                            begin
                            jump_state = 5'b00101;
                            end
                        2'b01:
                            begin
                            jump_state = 5'b00110;
                            end
                        2'b10:
                            begin
                            jump_state = 5'b00111;
                            end
                        2'b11:
                            begin
                            jump_state = 5'b01000;
                            end
                    endcase
                end
                2'b10: begin	
                    case(now_floor)
                        2'b00:
                            begin
                            jump_state = 5'b01001;
                            end
                        2'b01:
                            begin
                            jump_state = 5'b01010;
                            end
                        2'b10:
                            begin
                            jump_state = 5'b01011;
                            end
                        2'b11:
                            begin
                            jump_state = 5'b01100;
                            end
                    endcase
                end
                2'b11: begin	
                    case(now_floor)
                        2'b00:
                            begin
                            jump_state = 5'b01101;
                            end
                        2'b01:
                            begin
                            jump_state = 5'b01110;
                            end
                        2'b10:
                            begin
                            jump_state = 5'b01111;
                            end
                        2'b11:
                            begin
                            jump_state = 5'b10000;
                            end
                    endcase
                end
            endcase
       end
	endfunction
	
	always @(posedge clk) begin
		if (press_in1 || press_out1_up) begin
			if (direction == 2'b00 && door_state == 0) begin
				if(now_floor > 0)	
					direction <= 2'b10;
			end
			
			if (pointer == 2'b00) begin
				if (now_floor > 0)	
					pointer <= 2'b10;
				else begin
					if (press_out1_up == 1)
						pointer <= 2'b01;
				end
			end
		end

		if (press_in2 || press_out2_up || press_out2_down) begin
			if (direction == 2'b00 && door_state == 0) begin
				if (now_floor == 0)	
					direction <= 2'b01;
				if (now_floor > 1)	
					direction <= 2'b10;
			end
			
			if (pointer == 2'b00) begin
				if(now_floor == 0)	
					pointer <= 2'b01;
				else if(now_floor > 1)	
					pointer <= 2'b10;
				else begin
					if(press_out2_down == 1)
						pointer <= 2'b10;
					if(press_out2_up == 1)
						pointer <= 2'b01;
				end
			end
		end
		
		if (press_in3 || press_out3_up || press_out3_down) begin
			if (direction == 2'b00 && door_state == 0) begin
				if (now_floor == 3)	
					direction <= 2'b10;
				if (now_floor < 2)	
					direction <= 2'b01;
			end
			
			if (pointer == 2'b00) begin
				if (now_floor == 3)	
					pointer <= 2'b10;
				else if (now_floor < 2)	
					pointer <= 2'b01;
				else begin
					if (press_out3_down == 1)
						pointer <= 2'b10;
					if (press_out3_up == 1)
						pointer <= 2'b01;
				end
			end
		end
		
		if(press_in4 || press_out4_down) begin
			if(direction == 2'b00 && door_state == 0) begin
				if(now_floor < 3)	
					direction <= 2'b01;
			end
			
			if(pointer == 2'b00) begin
				if(now_floor < 3)	
					pointer <= 2'b01;
				else begin
					if(press_out4_down == 1)
						pointer <= 2'b10;
				end
			end
		end
		
		request_total = {press_in1 | press_out1_up, press_in2 | press_out2_up | press_out2_down, 
					press_in3 | press_out3_up | press_out3_down, press_in4 | press_out4_down};	
					
	
		if (n == max) begin
			n <= 0;
			case(state)
                5'b00000: begin
                        if(door_state == 1)	
                            state <= 5'b00000;
                        else begin				
                            case(request_total)
                                4'b0000:	
                                    begin
                                    state <= 5'b00000;
                                    pointer <= 2'b00;
                                    direction <= 2'b00;
                                    end
                                4'b0001:	
                                    begin
                                    state = jump_state(4-1);
                                    end
                                4'b0010:	
                                    begin
                                    state = jump_state(3-1);
                                    end
                                4'b0011:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        if(press_out3_down == 1 && press_out3_up == 0)
                                            state = jump_state(4-1);
                                        else
                                            state = jump_state(3-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(4-1);
                                        end
                                    endcase
                                    end
                                4'b0100:	
                                    begin
                                    state = jump_state(2-1);
                                    end
                                4'b0101:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(4-1);
                                        end
                                    2'b10:	
                                        begin
                                        if(press_out2_down == 0 && press_out2_up == 1)
                                            state = jump_state(4-1);
                                        else
                                            state = jump_state(2-1);
                                        end
                                    endcase
                                    end
                                4'b0110:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            if(press_out3_down == 1 && press_out3_up == 0 && press_out2_down == 1 && press_out2_up == 0 && press_in2 == 0 && press_in3 == 0)
                                                state = jump_state(3-1);
                                            else
                                                state = jump_state(2-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            if(press_out3_down == 0 && press_out3_up == 1 && press_out2_down == 0 && press_out2_up == 1 && press_in2 == 0 && press_in3 == 0)
                                                state = jump_state(2-1);
                                            else
                                                state = jump_state(3-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        if(press_out2_up == 0 && press_out2_down == 1)
                                        begin
                                            if(press_out3_up == 0 && press_out3_down == 1 && now_floor == 2'b10)
                                                pointer <= 2'b10;
                                            else
                                                state = jump_state(3-1);
                                        end
                                        else
                                            state = jump_state(2-1);
                                        end
                                    2'b10:	
                                        begin
                                        if(press_out3_down == 0 && press_out3_up == 1)
                                        begin
                                            if(press_out2_down == 0 && press_out2_up == 1 && now_floor == 2'b01) 
                                                pointer <= 2'b01;
                                            else
                                                state = jump_state(2-1);
                                        end
                                        else
                                            state = jump_state(3-1);
                                        end
                                    endcase
                                    end
                                4'b0111:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        if(press_out2_down == 1 && press_out2_up == 0)
                                        begin
                                            if(press_out3_down == 1 && press_out3_up == 0)
                                                state = jump_state(4-1);
                                            else
                                                state = jump_state(3-1);
                                        end
                                        else
                                            state = jump_state(2-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(4-1);
                                        end
                                    endcase
                                    end
                                4'b1000:	
                                    begin
                                    state = jump_state(1-1);
                                    end
                                4'b1001:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
        
                                            end
                                        2'b10:	
                                            begin
        
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(4-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    endcase
                                    end
                                4'b1010:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
        
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        if(press_out3_up == 0 && press_out3_down == 1)
                                            state = jump_state(1-1);
                                        else
                                            state = jump_state(3-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    endcase
                                    end
                                4'b1011:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
                                            
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        if(press_out3_up == 0 && press_out3_down == 1)
                                            state = jump_state(4-1);
                                        else
                                            state = jump_state(3-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    endcase
                                    end
                                4'b1100:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    2'b10:	
                                        begin
                                        if(press_out2_down == 0 && press_out2_up == 1)
                                            state = jump_state(1-1);
                                        else
                                            state = jump_state(2-1);
                                        end
                                    endcase
                                    end
                                4'b1101:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
        
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(4-1);
                                        end
                                    2'b10:	
                                        begin
                                        if(press_out2_down == 0 && press_out2_up == 1)
                                            state = jump_state(1-1);
                                        else
                                            state = jump_state(2-1);
                                        end
                                    endcase
                                    end
                                4'b1110:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
        
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    2'b10:	
                                        begin
                                        if(press_out3_down == 0 && press_out3_up == 1)
                                        begin
                                            if(press_out2_down == 0 && press_out2_up == 1)
                                                state = jump_state(1-1);
                                            else
                                                state = jump_state(2-1);
                                        end
                                        else
                                            state = jump_state(3-1);
                                        end
                                    endcase
                                    end
                                4'b1111:	
                                    begin
                                    case(pointer)
                                    2'b00:	
                                        begin
                                        case(now_floor)
                                        2'b00:	
                                            begin
                                            state = jump_state(1-1);
                                            end
                                        2'b01:	
                                            begin
                                            state = jump_state(2-1);
                                            end
                                        2'b10:	
                                            begin
                                            state = jump_state(3-1);
                                            end
                                        2'b11:	
                                            begin
                                            state = jump_state(4-1);
                                            end
                                        endcase
                                        end
                                    2'b01:	
                                        begin
                                        state = jump_state(1-1);
                                        end
                                    2'b10:	
                                        begin
                                        state = jump_state(4-4);
                                        end
                                    endcase
                                    end
                            endcase
                        end
                end
                5'b00001: begin
                        if(press_out1_up == 1)
                            pointer <= 2'b01;
                        state <= 5'b00000;
                        now_floor <= 2'b00;
                        direction <= 2'b00;
                end
                5'b00010: begin
                        if(press_in2 == 1 ||
                            (press_out2_down == 1 && pointer == 2'b10) ||
                            (press_out2_up == 1 && pointer == 2'b01))	
                            state <= 5'b00110;
                        else begin
                            state <= 5'b00001;
                            now_floor <= 2'b00;
                            direction <= 2'b10;
                            pointer <= 2'b10;
                        end
                end
                5'b00011: begin
                    if(press_in3 == 1 ||
                        (press_out3_down == 1 && pointer == 2'b10) ||
                        (press_out3_up == 1 && pointer == 2'b01))	
                        state <= 5'b01011;
                    else begin
                        state <= 5'b00010;
                        now_floor <= 2'b01;
                        direction <= 2'b10;
                        pointer <= 2'b10;
                    end
                end
                5'b00100: begin
                    if(press_in4 == 1 || press_out4_down == 1)	
                        state <= 5'b10000;
                    else begin
                        state <= 5'b00011;
                        now_floor <= 2'b10;
                        direction <= 2'b10;
                        pointer <= 2'b10;
                    end
                end
                5'b00101: begin
                    if(press_in1 == 1 || press_out1_up == 1)	
                        state <= 5'b00001;
                    else begin
                        state <= 5'b00110;
                        now_floor <= 2'b01;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b00110: begin
                    if (press_out2_up == 0 && press_out2_down == 1 && (request_total == 4 ||
                       (press_out3_up == 0 && press_out3_down == 1 && request_total == 6)))
                        pointer <= 2'b10;
                    if (press_out2_up == 1 && press_out2_down == 0 && (request_total == 4 ||
                       (press_out3_up == 1 && press_out3_down == 0 && request_total == 6)))
                        pointer <= 2'b01;
                    state <= 5'b00000;
                    direction <= 2'b00;
                    now_floor <= 2'b01;
                end
                5'b00111: begin
                    if (press_in3 == 1 ||
                       (press_out3_down == 1 && pointer == 2'b10) ||
                       (press_out3_up == 1 && pointer == 2'b01))	
                        state <= 5'b01011;
                    else begin
                        state <= 5'b00110;
                        now_floor <= 2'b01;
                        direction <= 2'b10;
                        pointer <= 2'b10;
                    end
                end
                5'b01000: begin
                    if (press_in4 == 1 || press_out4_down == 1)	
                        state <= 5'b10000;
                    else begin
                        state <= 5'b00111;
                        now_floor <= 2'b10;
                        direction <= 2'b10;
                        pointer <= 2'b10;
                    end
                end
                5'b01001: begin
                    if (press_in1 == 1 || press_out1_up == 1)	
                        state <= 5'b00001;
                    else begin
                        state <= 5'b01010;
                        now_floor <= 2'b01;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b01010: begin
                    if (press_in2 == 1 ||
                       (press_out2_down == 1 && pointer == 2'b10) ||
                       (press_out2_up == 1 && pointer == 2'b01))	
                        state <= 5'b00110;
                    else begin
                        state <= 5'b01011;
                        now_floor <= 2'b10;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b01011: begin
                    if (press_out3_up == 0 && press_out3_down == 1 && (request_total == 2 ||
                       (request_total == 6 && press_out2_up == 0 && press_out2_down == 1)))
                        pointer <= 2'b10;
                    if (press_out3_up == 1 && press_out3_down == 0 && (request_total == 2 ||
                       (request_total == 6 && press_out2_up == 1 && press_out2_down == 0)))
                        pointer <= 2'b01;
                    state <= 5'b00000;
                    now_floor <= 2'b10;
                    direction <= 2'b00;
                end
                5'b01100: begin
                    if (press_in4 == 1 || press_out4_down == 1)	
                        state <= 5'b10000;
                    else begin
                        state <= 5'b01011;
                        now_floor <= 2'b10;
                        direction <= 2'b10;
                        pointer <= 2'b10;
                    end
                end
                5'b01101: begin
                    if(press_in1 == 1 || press_out1_up == 1)	
                        state <= 5'b00001;
                    else begin
                        state <= 5'b01110;
                        now_floor <= 2'b01;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b01110: begin
                    if (press_in2 == 1 ||
                       (press_out2_down == 1 && pointer == 2'b10) ||
                       (press_out2_up == 1 && pointer == 2'b01))	
                        state <= 5'b00110;
                    else begin
                        state <= 5'b01111;
                        now_floor <= 2'b10;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b01111: begin
                    if (press_in3 == 1 ||
                       (press_out3_down == 1 && pointer == 2'b10) ||
                       (press_out3_up == 1 && pointer == 2'b01))	
                        state <= 5'b01011;
                    else begin
                        state <= 5'b10000;
                        now_floor <= 2'b11;
                        direction <= 2'b01;
                        pointer <= 2'b01;
                    end
                end
                5'b10000: begin
                    if (press_out4_down == 1)
                        pointer <= 2'b10;
                    state <= 5'b00000;
                    now_floor <= 2'b11;
                    direction <= 2'b00;
                end
            endcase
		end
		else n <= n + 1;
    end
	
endmodule
