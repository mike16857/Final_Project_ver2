module top_vga_display(
  input            clk,
  input            rst,
  input            now_floor,
  output reg [3:0] vgaRed,
  output reg [3:0] vgaGreen,
  output reg [3:0] vgaBlue,
  output           hsync,
  output           vsync
);

wire [11:0] data;
wire clk_25MHz;
wire clk_22;
wire [16:0] pixel_addr;
wire [11:0] pixel_F1;
wire [11:0] pixel_F2;
wire [11:0] pixel_F3;
wire [11:0] pixel_F4;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480

//assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;

// Frequency Divider
clock_divisor clk_wiz_0_inst(
  .clk(clk),
  .clk1(clk_25MHz),
  .clk22(clk_22)
);

// Reduce frame address from 640x480 to 320x240
mem_addr_gen mem_addr_gen_inst(
  .clk(clk_22),
  .rst(rst),
  .h_cnt(h_cnt),
  .v_cnt(v_cnt),
  .pixel_addr(pixel_addr)
);
     
// Use reduced 320x240 address to output the saved picture from RAM 
blk_mem_gen_0 floor1(
  .clka(clk_25MHz),
  .wea(0),
  .addra(pixel_addr),
  .dina(data[11:0]),
  .douta(pixel_F1)
); 

blk_mem_gen_1 floor2(
  .clka(clk_25MHz),
  .wea(0),
  .addra(pixel_addr),
  .dina(data[11:0]),
  .douta(pixel_F2)
);

blk_mem_gen_2 floor3(
  .clka(clk_25MHz),
  .wea(0),
  .addra(pixel_addr),
  .dina(data[11:0]),
  .douta(pixel_F3)
);

blk_mem_gen_3 floor4(
  .clka(clk_25MHz),
  .wea(0),
  .addra(pixel_addr),
  .dina(data[11:0]),
  .douta(pixel_F4)
);

    always @*
        if (v_cnt < 40 || v_cnt > 440)
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if (v_cnt > 150 && v_cnt < 330 && h_cnt > 405 && h_cnt < 555)
            case (now_floor)
                2'b00: {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel_F1 : 12'h0;
                2'b01: {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel_F2 : 12'h0;
                2'b10: {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel_F3 : 12'h0;
                2'b11: {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel_F4 : 12'h0;
                default: {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            endcase
        else
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            
// Render the picture by VGA controller
vga_controller   vga_inst(
  .pclk(clk_25MHz),
  .reset(rst),
  .hsync(hsync),
  .vsync(vsync),
  .valid(valid),
  .h_cnt(h_cnt),
  .v_cnt(v_cnt)
);
      
endmodule
