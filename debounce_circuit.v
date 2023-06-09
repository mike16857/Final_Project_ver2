`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/24 21:26:47
// Design Name: 
// Module Name: debounce_circuit
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


module debounce_circuit(
    input wire clk, rst, pb_in,
    output reg pb_debounced
    );
    
    reg [3:0] debounce_window;
    reg pb_debounced_next;
    
    always @(posedge clk, posedge rst)
        if(rst)
            debounce_window <= 4'b0000;
        else
            debounce_window <= {debounce_window[2:0], pb_in};
    
    always @*
        if(debounce_window == 4'b1111)
            pb_debounced_next = 1'b1;
        else
            pb_debounced_next = 1'b0;
            
    always @(posedge clk, posedge rst)
        if(rst)
            pb_debounced <= 1'b0;
        else
            pb_debounced <= pb_debounced_next;
            
endmodule
