`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 01:27:04
// Design Name: 
// Module Name: freqdiv_100M
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



module freqdiv_100Hz( 
    input wire clk, rst,
    output reg clk_out
    );
    
    parameter divisor = 28'd500000;
    reg [27:0] cnt;
    reg [27:0] cnt_next;
    wire t_flag;
    
    always @*
            cnt_next = cnt + 28'd1;
        
    assign t_flag = (cnt == (divisor - 28'd1))? 1'b1 : 1'b0;
    
    always @(posedge clk, posedge rst)
        if(rst || t_flag)
            cnt <= 28'b0;
        else
            cnt <= cnt_next;
            
    always @(posedge clk, posedge rst)
        if(rst) 
            clk_out <= 0;
        else
            if(t_flag)
                clk_out <= ~clk_out;
            else
                clk_out <= clk_out;
          
endmodule
