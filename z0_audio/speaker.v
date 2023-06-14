`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:29:06 05/02/2012 
// Design Name: 
// Module Name:    speaker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speaker(
    // I/O declaration
    input       clk,  // clock from the crystal
    input       rst,  // active low reset
    input [5:0] state,
    output      audio_mclk, // master clock
    output      audio_lrck, // left-right clock
    output      audio_sck, // serial clock
    output      audio_sdin // serial audio data input
);

// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;
reg [21:0] note_div;

// Note generation
note_gen Ung(
  .clk(clk), // clock from crystal
  .rst(rst), // active low reset
  .note_div(note_div), // div for note generation
  .audio_left(audio_in_left), // left sound audio
  .audio_right(audio_in_right) // right sound audio
);

// Speaker controllor
speaker_control Usc(
  .clk(clk),  // clock from the crystal
  .rst(rst),  // active low reset
  .audio_in_left(audio_in_left), // left channel audio data input
  .audio_in_right(audio_in_right), // right channel audio data input
  .audio_mclk(audio_mclk), // master clock
  .audio_lrck(audio_lrck), // left-right clock
  .audio_sck(audio_sck), // serial clock
  .audio_sdin(audio_sdin) // serial audio data input
);

    always @*
        case (state)
            5'b00001: note_div = 22'd95420; // 1f
            5'b00110: note_div = 22'd85034; // 2f
            5'b01011: note_div = 22'd75758; // 3f
            5'b10000: note_div = 22'd71633; // 4f
            default: note_div = 0;
        endcase

endmodule
