`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/22 14:12:07
// Design Name: 
// Module Name: lab2_2
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


module BCD_ToSSD_decoder(
    input wire [3:0] in,
    output reg [7:0] SSD
    );
    
    always @*
        case(in)
            4'd0: SSD = 8'b0000_0011; //  door open "O"
            4'd1: SSD = 8'b1001_1111; // 1
            4'd2: SSD = 8'b0010_0101; // 2
            4'd3: SSD = 8'b0000_1101; // 3
            4'd4: SSD = 8'b1001_1001; // 4
            4'd5: SSD = 8'b0011_1011; // pointer point upward "£v"
            4'd6: SSD = 8'b1111_1101; // elevator not moving "-"
            4'd7: SSD = 8'b1100_0111; // pointer point downward "£º"
            4'd8: SSD = 8'b0000_0001; // 8
            4'd9: SSD = 8'b0000_1001;
            4'd10: SSD = 8'b0111_1111; // elevator go up "¤@"
            4'd11: SSD = 8'b1110_1111; // elevator go down "_"
            4'd12: SSD = 8'b0110_0011; //  door close "C"
            default: SSD = 8'b1111_1111;
         endcase  
endmodule
