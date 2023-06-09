`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/16 14:09:01
// Design Name: 
// Module Name: scan_control
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


module scan_ctrl(
    input wire [1:0] ssd_ctrl_en,
    input wire [3:0] in3, in2, in1, in0,
    output reg [3:0] ssd_ctrl, 
    output reg [3:0] ssd_in  
    );
    
    always@*
        case (ssd_ctrl_en)
            2'b00:
                begin
                ssd_ctrl = 4'b0111;
                ssd_in = in3;
                end
            2'b01:
                begin
                ssd_ctrl = 4'b1011;
                ssd_in = in2;
                end
            2'b10:
                begin
                ssd_ctrl = 4'b1101;
                ssd_in = in1;
                end
            2'b11:
                begin
                ssd_ctrl = 4'b1110;
                ssd_in = in0;
                end
            default:
                begin
                ssd_ctrl = 4'b1111;
                ssd_in = 4'd0;
                end
        endcase
    
endmodule
