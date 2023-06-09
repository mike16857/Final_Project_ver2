`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/16 22:29:27
// Design Name: 
// Module Name: freqdiv_27bit_BinUpCnt
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

`define bitlength 27

module freqdiv_27bit_BinUpCnt(
    input wire clk, rst_p,
    output reg clk_out, 
    output reg [1:0] clk_ctrl  
    );
    
    reg [8:0] cnt_a;
    reg [14:0] cnt_b;
    reg [`bitlength-1:0]cnt_next;
    
    always @*
        cnt_next = {clk_out, cnt_a, clk_ctrl, cnt_b} + `bitlength'b1;
        
    always @(posedge clk, posedge rst_p)
        if(rst_p)
            {clk_out, cnt_a, clk_ctrl, cnt_b} <= `bitlength'd0;
        else
            {clk_out, cnt_a, clk_ctrl, cnt_b} <= cnt_next;
endmodule
