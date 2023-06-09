`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 01:56:08
// Design Name: 
// Module Name: keyboard_in_fsm
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

`define STAND_BY  5'b0_000_0
`define FIRST_UP  5'b0_001_0
`define SECOND_UP 5'b0_010_0
`define SECOND_DW 5'b0_010_1
`define THIRD_UP  5'b0_011_0
`define THIRD_DW  5'b0_011_1
//`define FOURTH_UP 5'b0_100_0
`define FOURTH_DW 5'b0_100_1
//`define FIFTH_DW  5'b0_101_1
`define ELEV_1F   5'b1_001_0
`define ELEV_2F   5'b1_010_0
`define ELEV_3F   5'b1_011_0
`define ELEV_4F   5'b1_100_0
//`define ELEV_5F   5'b1_101_0


module keyboard_in_fsm(
    input            clk, rst,
    input            key_valid,
    input      [8:0] last_change,
    output reg [4:0] state
//    output reg       f1u, f2u, f2d, f3u, f3d, f4u, f4d, f5d,
//    output reg       to1, to2, to3, to4, to5
    );
    
//    reg [4:0] state;
    reg [4:0] next_s;
//    reg f1u, f2u, f2d, f3u, f3d, f4u, f4d, f5d;
//    reg to1, to2, to3, to4, to5;
    
    always @(posedge clk, posedge rst)
        if (rst) state <= `STAND_BY;
        else state <= next_s;
        
    always @* begin
//        f1u = 0;
//        f2u = 0;
//        f2d = 0;
//        f3u = 0;
//        f3d = 0;
//        f4u = 0;
//        f4d = 0;
//        f5d = 0;
//        to1 = 0;
//        to2 = 0;
//        to3 = 0;
//        to4 = 0;
//        to5 = 0;
        next_s = `STAND_BY;
        case (state) 
            `STAND_BY:
                if (key_valid && (last_change == 9'h16)) begin
                    next_s = `FIRST_UP;
                    //f1u = 1;
                end
                else if (key_valid && (last_change == 9'h15)) begin 
                    next_s = `SECOND_UP;
                    //f2u = 1;
                end
                else if (key_valid && (last_change == 9'h1D)) begin 
                    next_s = `SECOND_DW;
                    //f2d = 1;
                end
                else if (key_valid && (last_change == 9'h1C)) begin 
                    next_s = `THIRD_UP;
                    //f3u = 1;
                end
                else if (key_valid && (last_change == 9'h1B)) begin 
                    next_s = `THIRD_DW;
                    //f3d = 1;
                end
//                else if (key_valid && (last_change == 9'h1A)) begin 
//                    next_s = `FOURTH_UP;
//                    //f4u = 1;
//                end
                else if (key_valid && (last_change == 9'h22)) begin
                    next_s = `FOURTH_DW;
                    //f4d = 1;
                end
//                else if (key_valid && (last_change == 9'h2E)) begin 
//                    next_s = `FIFTH_DW;
//                    //f5d = 1;
//                end
                else if (key_valid && (last_change == 9'h69)) begin 
                    next_s = `ELEV_1F;
                    //to1 = 1;
                end
                else if (key_valid && (last_change == 9'h72)) begin 
                    next_s = `ELEV_2F;
                    //to2 = 1;
                end
                else if (key_valid && (last_change == 9'h7A)) begin 
                    next_s = `ELEV_3F;
                   // to3 = 1;
                end
                else if (key_valid && (last_change == 9'h6B)) begin 
                    next_s = `ELEV_4F;
                   // to4 = 1;
                end
//                else if (key_valid && (last_change == 9'h73)) begin 
//                    next_s = `ELEV_5F;
//                    //to5 = 1;
//                end
                else next_s = `STAND_BY;
            `FIRST_UP:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `FIRST_UP;
            `SECOND_UP:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `SECOND_UP;            
            `SECOND_DW:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `SECOND_DW;
            `THIRD_UP:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `THIRD_UP;
            `THIRD_DW:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `THIRD_DW;
//            `FOURTH_UP:
//                if (key_valid) next_s = `STAND_BY;
//                else next_s = `FOURTH_UP;           
            `FOURTH_DW:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `FOURTH_DW;            
//            `FIFTH_DW:
//                if (key_valid) next_s = `STAND_BY;
//                else next_s = `FIFTH_DW;            
            `ELEV_1F:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `ELEV_1F;           
            `ELEV_2F:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `ELEV_2F;           
            `ELEV_3F:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `ELEV_3F;           
            `ELEV_4F:
                if (key_valid) next_s = `STAND_BY;
                else next_s = `ELEV_4F;            
//            `ELEV_5F:
//                if (key_valid) next_s = `STAND_BY;
//                else next_s = `ELEV_5F;            
        endcase
//        case (state)
//                `FIRST_UP: f1u = 1;
//                `SECOND_UP: f2u = 1;
//                `SECOND_DW: f2d = 1;
//                `THIRD_UP: f3u = 1;
//                `THIRD_DW: f3d = 1;
//                `FOURTH_UP: f4u = 1;
//                `FOURTH_DW: f4d = 1;
//                `FIFTH_DW: f5d = 1;
//                `ELEV_1F: to1 = 1;
//                `ELEV_2F: to2 = 1;
//                `ELEV_3F: to3 = 1;
//                `ELEV_4F: to4 = 1;
//                `ELEV_5F: to5 = 1;
//                `STAND_BY: ;
//                default: begin 
//                    f1u = 0;
//                    f2u = 0;
//                    f2d = 0;
//                    f3u = 0;
//                    f3d = 0;
//                    f4u = 0;
//                    f4d = 0;
//                    f5d = 0;
//                    to1 = 0;
//                    to2 = 0;
//                    to3 = 0;
//                    to4 = 0;
//                    to5 = 0;
//                end
//        endcase        
    end
     
endmodule
