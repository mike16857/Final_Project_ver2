module mem_addr_gen(
    input             clk,
    input             rst,
    input      [9:0]  h_cnt,
    input      [9:0]  v_cnt,
    output reg [16:0] pixel_addr
);
    
//    reg [7:0] position; 
//assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1)+ position*320 )% 76800;  //640*480 --> 320*240 
//always @ (posedge clk or posedge rst) begin
//  if(rst)
//    position <= 0;
//  else if(position < 239)
//    position <= position + 1;
//  else
//    position <= 0;
//end
    always@*
        if(v_cnt < 128 | v_cnt >191)
            pixel_addr = 0;
        else if(h_cnt < 64)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt;
        else if(h_cnt < 128)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 64;
        else if(h_cnt < 192)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 128;
        else if(h_cnt < 256)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 192;
        else if(h_cnt < 320)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 256;
        else if(h_cnt < 384)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 320;
        else if(h_cnt < 448)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 384;
        else if(h_cnt < 512)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 448;
        else if(h_cnt < 576)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 512;
        else if(h_cnt < 640)
            pixel_addr = (v_cnt - 128) * 64 + h_cnt - 576;
        else pixel_addr = 0;
    
endmodule