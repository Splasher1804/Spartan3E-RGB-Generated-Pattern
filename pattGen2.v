module pattGen2 (
	//Lista de porturi
	output	[2:0] rgb_o,
	input	[8:0] row_i,
	input	[9:0] column_i
	
);
//Lista de parametrii
localparam BLACK  = 3'b000;
localparam RED    = 3'b100;
localparam GREEN  = 3'b010;
localparam BLUE   = 3'b001;
localparam CYAN   = 3'b011;
localparam PINK   = 3'b101;
localparam YELLOW = 3'b110;
localparam WHITE  = 3'b111;

localparam x0 = 55;
localparam x1 = 110;
localparam x2 = 165;
localparam x3 = 220;
localparam x4 = 275;
localparam x5 = 330;
localparam x6 = 405;


//Semnale interne
// N/A

//Cod
//always @(*)
//if ((column_i > x0) & (column_i < x1)) rgb_o = RED; else
//											rgb_o = GREEN;

//assign rgb_o = row[9:7] ultimii cei mai semnificativi

assign rgb_o = (row_i < x0)? BLACK : 
               (row_i < x1)? BLUE  : 
			   (row_i < x2)? GREEN :
			   (row_i < x3)? CYAN  :
			   (row_i < x4)? RED   :
			   (row_i < x5)? PINK  :
			   (row_i < x6)? YELLOW : WHITE;

endmodule