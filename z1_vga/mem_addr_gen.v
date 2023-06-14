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
    always @*
        if (v_cnt < 40 || v_cnt > 440)
            pixel_addr = (v_cnt) * 180 + h_cnt;
        else if (v_cnt > 150 && v_cnt < 330 && h_cnt > 405 && h_cnt < 555)
            pixel_addr = (v_cnt - 150) * 180 + h_cnt - 405;
        else 
            pixel_addr = 0;
               
endmodule
