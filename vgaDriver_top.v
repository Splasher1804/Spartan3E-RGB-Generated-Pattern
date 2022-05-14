
module vgaDriver_top (
input	   clk_i  ,   // clock input, 50MHz
input	   reset_i,
input	   sw_o,	// reset active high
output   hSync_o,	// Horizontal sync video output
output   vSync_o,	// vertical sync video output
output   red_o  ,	// red video output
output   green_o,	// green video output
output   blue_o     // blue video output
);
wire [4:0] internal_red_o  ; 
wire [5:0] internal_green_o;
wire [4:0] internal_blue_o ;

//sarme de legatura intre vga driver si pattern gen
//wire [2:0] rgb;
reg [2:0] rgb; 
wire [2:0] rgb_1; 
wire [2:0] rgb_2; // [2] - Red, [1] - Green, [0] - Blue
wire [8:0] row;
//wire [9:0] column;

assign red_o   = internal_red_o  [4];
assign green_o = internal_green_o[5];
assign blue_o  = internal_blue_o [4];
// code

vgaDriver i_vgaDriver(
  .clk_i     (clk_i                 )							 ,	// clock input, 50MHz
  .reset_i   (reset_i               )							 ,	// reset active high
  //.rgb_i   (16'b00000_100000_10000)
  .rgb_i     ({rgb[2], 4'b0000, rgb[1], 5'b00000, rgb[0], 4'b0000}), // pixel colour input (R[4:0], G[5:0], B[4:0])  [15:0]
  .row_o     (     row              )							 ,	// Not used in etapa1
  .column_o  (      column          )							 ,	// Not used in etapa1
  .red_o     (internal_red_o        )							 ,	// red video output                             [4:0] 
  .green_o   (internal_green_o      )							 ,	// green video output                           [5:0] 
  .blue_o    (internal_blue_o       )							 ,	// blue video output                            [4:0] 
  .hSync_o   (hSync_o               )							 ,	// Horizontal sync video output
  .vSync_o   (vSync_o               )								// vertical sync video output
);


pattGen2 i_pattGen2(
	.rgb_o		(rgb_1), //3 bits
	.row_i		(row),
	.column_i	(column)
);

img_processor i_img_processor(
  .rgb_o    (rgb_2),
  .rgb_i    (rgb_1)
);

always @(*)
if (sw_o ==  0)  rgb <= rgb_1; else
                 rgb <= rgb_2; 


endmodule // vgaDriver
