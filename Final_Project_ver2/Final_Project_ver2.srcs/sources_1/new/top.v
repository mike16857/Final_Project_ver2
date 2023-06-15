`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 03:28:59
// Design Name: 
// Module Name: top
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

module top(
    input clk, rst,
    input pbL, pbR,
    inout PS2_DATA, PS2_CLK, // keyboard input
    /* SSD */
    output [3:0] ctrl,
    output [7:0] segs,
    /* LED */
    output  floor1_led,				//??1的按???的LED?
    output  floor2_led,                //??2的按???的LED?
    output  floor3_led,                //??3的按???的LED?
    output  floor4_led,                //??4的按???的LED?
    output  door_open_led,            //????的LED?
    output  door_close_led,            //????的LED?
	output  out1_up_led,			//?梯外的1?↑led
    output  out2_up_led,            //?梯外的2?↑led
    output  out2_down_led,            //?梯外的2?↓led
    output  out3_up_led,            //?梯外的3?↑led
    output  out3_down_led,            //?梯外的3?↓led
    output  out4_down_led,           //?梯外的4?↓led    
    /* vga output */
    output [3:0] vgaRed,     
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,
    /* audio output */
    output audio_mclk, // master clock
    output audio_lrck, // left-right clock
    output audio_sck, // serial clock
    output audio_sdin // serial audio data input                                              
    );
    
    wire       clk_out;
    wire       clk_100Hz;
    wire [1:0] clk_ctrl;
    
    wire [8:0] last_change;
    wire       key_valid;
    
    wire       door_open_pbL_d, door_close_pbR_d;
    
    wire [4:0] keyboard_state;
    reg        f1u, f2u, f2d, f3u, f3d, f4u, f4d, f5d;
    reg        to1, to2, to3, to4, to5;
    
    wire       press_in1, press_in2, press_in3, press_in4;
    wire       press_out1_up, press_out2_up, press_out2_down, press_out3_up, press_out3_down, press_out4_down;
    
    wire [4:0] state;
    wire [1:0] pointer;
    wire [3:0] request_total;
    wire       door_state;
    wire [1:0] now_floor;
    wire [1:0] direction;
        
    reg  [3:0] digit0, digit1;
    reg  [3:0] digit2, digit3;    
    wire [3:0] ssd_in;
    
    freqdiv_27bit_BinUpCnt U_fd_ctrl(
        .clk                (clk), 
        .rst_p              (rst),
        .clk_out            (clk_out), 
        .clk_ctrl           (clk_ctrl)  
    );
    
    freqdiv_100Hz U_100Hz(
        .clk                (clk), 
        .rst                (rst),
        .clk_out            (clk_100Hz)
    );
    
    debounce_circuit U_dcL(
        .clk                (clk_100Hz),
        .rst                (rst),
        .pb_in              (pbL),
        .pb_debounced       (door_open_pbL_d)
    );
    
    debounce_circuit U_dcR(
        .clk                (clk_100Hz),
        .rst                (rst),
        .pb_in              (pbR),
        .pb_debounced       (door_close_pbR_d)
    );
    
    KeyboardDecoder U_keyboard(
        .key_down           (),
        .last_change        (last_change),
        .key_valid          (key_valid),
        .PS2_DATA           (PS2_DATA),
        .PS2_CLK            (PS2_CLK),
        .rst                (rst),
        .clk                (clk)
    );
    
    keyboard_in_fsm U_key_in(
        .clk                (clk), 
        .rst                (rst),
        .last_change        (last_change),
        .key_valid          (key_valid),
        .state              (keyboard_state)
//        .f1u(f1u), 
//        .f2u(f2u), .f2d(f2d), 
//        .f3u(f3u), .f3d(f3d), 
//        .f4u(f4u), .f4d(f4d), 
//        .f5d(f5d),
//        .to1(to1), .to2(to2), .to3(to3), .to4(to4), .to5(to5)
    );
    
    always @*
        case (keyboard_state)
            `FIRST_UP: begin 
                f1u = 1;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end            
            `SECOND_UP: begin 
                f1u = 0;
                f2u = 1; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end
            `SECOND_DW: begin 
                f1u = 0;
                f2u = 0; f2d = 1;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end
            `THIRD_UP: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 1; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end
            `THIRD_DW: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 1;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end        
//            `FOURTH_UP: begin
//                f1u = 0;
//                f2u = 0; f2d = 0;
//                f3u = 0; f3d = 0;
//                f4u = 1; f4d = 0;
//                f5d = 0;
//                to1 = 0; to2 = 0;
//                to3 = 0; to4 = 0;
//                to5 = 0;
//            end        
            `FOURTH_DW: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 1;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end        
//            `FIFTH_DW: begin
//                f1u = 0;
//                f2u = 0; f2d = 0;
//                f3u = 0; f3d = 0;
//                f4u = 0; f4d = 0;
//                f5d = 1;
//                to1 = 0; to2 = 0;
//                to3 = 0; to4 = 0;
//                to5 = 0;
//            end        
            `ELEV_1F: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 1; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end        
            `ELEV_2F: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 1;
                to3 = 0; to4 = 0;
                to5 = 0;
            end        
            `ELEV_3F: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 1; to4 = 0;
                to5 = 0;
            end           
            `ELEV_4F: begin
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 1;
                to5 = 0;
            end           
//            `ELEV_5F: begin
//                f1u = 0;
//                f2u = 0; f2d = 0;
//                f3u = 0; f3d = 0;
//                f4u = 0; f4d = 0;
//                f5d = 0;
//                to1 = 0; to2 = 0;
//                to3 = 0; to4 = 0;
//                to5 = 1;
//            end           
            `STAND_BY: begin 
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end   
            default: begin 
                f1u = 0;
                f2u = 0; f2d = 0;
                f3u = 0; f3d = 0;
                f4u = 0; f4d = 0;
                f5d = 0;
                to1 = 0; to2 = 0;
                to3 = 0; to4 = 0;
                to5 = 0;
            end
        endcase
    
	ELEV_in_btn U_in_btn(
        .clk                (clk),
        .press1             (to1),
        .press2             (to2),
        .press3             (to3),
        .press4             (to4),
        .press_in1          (press_in1),
        .press_in2          (press_in2),
        .press_in3          (press_in3),
        .press_in4          (press_in4),
        .state              (state)
    );    
    
	ELEV_out_btn U_out_btn(
        .clk                (clk),
        .out1_up            (f1u),
        .out2_up            (f2u),
        .out2_down          (f2d),
        .out3_up            (f3u),
        .out3_down          (f3d),
        .out4_down          (f4d),
        .state              (state),
        .pointer            (pointer),
        .request_total      (request_total),
        .press_in1          (press_in1),
        .press_in2          (press_in2),
        .press_in3          (press_in3),
        .press_in4          (press_in4),                
        .press_out1_up      (press_out1_up),
        .press_out2_up      (press_out2_up),
        .press_out2_down    (press_out2_down),
        .press_out3_up      (press_out3_up),
        .press_out3_down    (press_out3_down),
        .press_out4_down    (press_out4_down)
//        .led_out_test_sw    (led_out_test_sw),
    );    
    
	FSM U_FSM(
        .clk                (clk),
        .door_state         (door_state),
        .press_out1_up      (press_out1_up),
        .press_out2_up      (press_out2_up),
        .press_out2_down    (press_out2_down),
        .press_out3_up      (press_out3_up),
        .press_out3_down    (press_out3_down),
        .press_out4_down    (press_out4_down),
        .press_in1          (press_in1),
        .press_in2          (press_in2),
        .press_in3          (press_in3),
        .press_in4          (press_in4),
        .now_floor          (now_floor),
        .state              (state),
        .direction          (direction),
        .pointer            (pointer),
        .request_total      (request_total)
    );
    
	door U_door(
        .clk                (clk),
        .direction          (direction),
        .state              (state),
        .door_open_sw       (door_open_pbL_d),
        .door_close_sw      (door_close_pbR_d),
        .door_state         (door_state)
    );        
    
	led u_led(
        .clk                (clk),
        .press_in1          (press_in1),
        .press_in2          (press_in2),
        .press_in3          (press_in3),
        .press_in4          (press_in4),
        .state              (state),
        .door_open_sw       (door_open_pbL_d),
        .door_close_sw      (door_close_pbR_d),
//        .call_state        (call_state),
//        .call_led1        (call_led1),
//        .call_led2        (call_led2),
        .press_out1_up      (press_out1_up),
        .press_out2_up      (press_out2_up),
        .press_out2_down    (press_out2_down),
        .press_out3_up      (press_out3_up),
        .press_out3_down    (press_out3_down),
        .press_out4_down    (press_out4_down),
        .led1               (floor1_led), // 1F
        .led2               (floor2_led), // 2F
        .led3               (floor3_led), // 3F
        .led4               (floor4_led), // 4F
        .door_open_led      (door_open_led),
        .door_close_led     (door_close_led),
        .out1_up_led        (out1_up_led),
        .out2_up_led        (out2_up_led),
        .out2_down_led      (out2_down_led),
        .out3_up_led        (out3_up_led),
        .out3_down_led      (out3_down_led),
        .out4_down_led      (out4_down_led)
    );
    
    always @* 
        case (now_floor)
            2'b00: digit0 = 4'd1;
            2'b01: digit0 = 4'd2;
            2'b10: digit0 = 4'd3;
            2'b11: digit0 = 4'd4;
            default: digit0 = 4'd8;
        endcase
        
    always @*       
        case (pointer)
            2'b00: digit1 = 4'd15;
            2'b01: digit1 = 4'd5;
            2'b10: digit1 = 4'd7;
            default: digit1 = 4'd9;
        endcase
    
    always @*
        if (~door_state) digit2 = 4'd12;
        else digit2 = 4'd0;
                   
    always @*
        case (direction)
            2'b00: digit3 = 4'd6;
            2'b01: digit3 = 4'd10;
            2'b10: digit3 = 4'd11;
            default: digit3 = 4'd8;
        endcase               
    
    top_vga_display U_VGA(
        .clk                (clk),
        .rst                (rst),
        .now_floor          (now_floor),
        .pointer            (pointer),
        .door_state         (door_state),
        .vgaRed             (vgaRed),
        .vgaGreen           (vgaGreen),
        .vgaBlue            (vgaBlue),
        .hsync              (hsync),
        .vsync              (vsync)
    );
    
    speaker U_speaker(
        .clk                (clk),  // clock from the crystal
        .rst                (rst),  // active low reset
        .state              (state),
        .audio_mclk         (audio_mclk), // master clock
        .audio_lrck         (audio_lrck), // left-right clock
        .audio_sck          (audio_sck), // serial clock
        .audio_sdin         (audio_sdin) // serial audio data input
    );
    
    scan_ctrl U_sc(
        .ssd_ctrl_en        (clk_ctrl),
        .in3                (digit3),
        .in2                (digit2),
        .in1                (digit1),
        .in0                (digit0),
        .ssd_ctrl           (ctrl),
        .ssd_in             (ssd_in)
    );
    
    BCD_ToSSD_decoder U_display(
        .in                 (ssd_in),
        .SSD                (segs)
    );
    
endmodule
