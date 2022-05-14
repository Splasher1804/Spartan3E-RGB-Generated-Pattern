//------------------------------------------------------------------------------
// University of Transilvania Brasov
// Proiect     : Laborator HDL
// Modul       : vgaDriver
// Autor       : Miu Mihai Florian
// Data        : May 9, 2022
//------------------------------------------------------------------------------
// Descriere   : Driver VGA: genereaza hSync, vSync.
//               Culoarea este primta pe baza randului si coloanei.
//               Frecventa de ceas configurabiula
//               5+6+5 biti de culoare
//               The color is given based on row and collumn.
//               The frequency is configurable
//               5 + 6 + 5 Bits for color
//                  +----------+
//                  | vgaDriver|--> vSync_o
//                  |          |--> hSync_o
//                  |          |
// row_o[8:0]    <--|          |--> red_o[4:0]
// column_o[9:0] <--|          |--> green_o[5:0]
// rgb_i[15:0]   -->|          |--> blue_o[4:0]
//                  |          |
// clk_i         -->|          |
// reset_i       -->|          |
//                  +----------+

`define hTfp_c	 10'd16		// Horizontal front porch (pixels)
`define hTpw_c	 10'd96 	// Horizontal pulse width time
`define hTbp_c	 10'd48		// Horizontal back porch
`define hTs_c	   10'd800	// Horizontal sync pulse time 

`define vTfp_c	 10'd10		// Vertical front porch (lines)
`define vTpw_c	 10'd2		// Vertical pulse width time
`define vTbp_c	 10'd33		// Vertical back porch
`define vTs_c	   10'd525	// Vertical lines

module vgaDriver (
input		    	      clk_i,		// clock input, 50MHz
input		    	      reset_i,	// reset active high
input      [15:0]	  rgb_i,		// pixel colour input (R[4:0], G[5:0], B[4:0])
output reg [8:0]		row_o,		// current row display on screen
output reg [9:0]		column_o,	// current column display on screen
output reg [4:0]    red_o,		// red video output
output reg [5:0]    green_o,	// green video output
output reg [4:0]    blue_o,		// blue video output
output reg  	      hSync_o,	// Horizontal sync video output
output reg  	      vSync_o		// vertical sync video output
);

parameter  CLOCK_DIV = 2;   // clock divider ratio (for 25MHz output)
                            // = 2 for fck=50MHz
                            // = 5 for fck=125MHz
reg [CLOCK_DIV-1:0]		clockEnable;	    // clock enable (25MHz period)
reg[9:0]	            hCounter;		      // horizontal counter
reg[9:0]	            vCounter;		      // vertical counter
reg		                hSyncR1;		      // delayed version of hSync_o
reg		                videoOn;		      // video display On

// frequency divider from system clock frequnecy to 25MHz (enable signal for the rest of the module)
always @(posedge clk_i or posedge reset_i)
if (reset_i)    clockEnable <= {{(CLOCK_DIV-1){1'b0}}, 1'b1}; else
                clockEnable <= {clockEnable[CLOCK_DIV-2:0], clockEnable[CLOCK_DIV-1]}; 

// horizontal (pixel) counter
always @(posedge clk_i or posedge reset_i)
if (reset_i)		hCounter <= 'b0; else
if (clockEnable[0])
	if (hCounter == (`hTs_c-1))
                hCounter <= 'b0; else
                hCounter <=  hCounter  + 1; 

// veritical (lines) counter
always @(posedge clk_i or posedge reset_i)
if (reset_i)		vCounter <= (`vTs_c - 1'b1); else
if (clockEnable[0])
	if (hSyncR1 & (~hSync_o))
		if(vCounter == (`vTs_c - 1))
                vCounter <= 10'b0; else
                vCounter <=  vCounter  + 1; 

// horizontal Sync output
always @(posedge clk_i or posedge reset_i)
if (reset_i)		hSync_o <= 1'b1; else
if (clockEnable[0])
	if (hCounter < `hTpw_c)	
                hSync_o <= 1'b0; else
                hSync_o <= 1'b1;

// delayed version of hSync_o for edge detection
always @(posedge clk_i or posedge reset_i)
if (reset_i)		      hSyncR1 <= 'b1; else
if (clockEnable[0])	  hSyncR1 <= hSync_o;

// vertical Sync output
always @(posedge clk_i or posedge reset_i)
if (reset_i)		vSync_o <= 1'b1; else
if (clockEnable[0])
	if (vCounter < `vTpw_c)
                vSync_o <= 1'b0; else
                vSync_o <= 1'b1;

// RGB outputs (black during video off)
always @(posedge clk_i or posedge reset_i)
if (reset_i)		{red_o, green_o, blue_o} <= 16'b0; else
if (clockEnable[0])
	if (videoOn)  {red_o, green_o, blue_o} <= rgb_i; else
                {red_o, green_o, blue_o} <= 16'b0;  // black on background

// current row displayed sent to the video client		
always @(posedge clk_i or posedge reset_i)
if (reset_i)		      row_o <= 9'b0; else
if (clockEnable[0])	  row_o <= (vCounter - `vTpw_c - `vTbp_c);

// current column displayed sent to the video client		
always @(posedge clk_i or posedge reset_i)
if (reset_i)		      column_o <= 10'b0; else
if (clockEnable[0])	  column_o <= (hCounter - `hTpw_c - `hTbp_c);

// video On window
always @(posedge clk_i or posedge reset_i)
if (reset_i)		videoOn <= 1'b0; else
if (clockEnable[0])
	if (	(vCounter >= (`vTpw_c + `vTbp_c)) && 
        (vCounter <= (`vTs_c  - `vTfp_c)) && 
        (hCounter >= (`hTpw_c + `hTbp_c)) && 
        (hCounter <= (`hTs_c  - `hTfp_c))) 
                videoOn <= 1'b1; else
                videoOn <= 1'b0;
                
endmodule // vgaDriver
