
module img_processor (
	input	   [2:0] rgb_i,
	output reg	[2:0] rgb_o
);


always @(rgb_i)
	case (rgb_i)
		3'b000 : rgb_o = 3'b001;
		3'b001 : rgb_o = 3'b010;
		3'b010 : rgb_o = 3'b100;
		3'b011 : rgb_o = 3'b011;
		3'b100 : rgb_o = 3'b000;
		3'b101 : rgb_o = 3'b110;
		3'b110 : rgb_o = 3'b111;
		3'b111 : rgb_o = 3'b101;
		default: rgb_o = 1'bx; 
	endcase	


endmodule // vgaDriver

/*module img_processor(
    //Lista de porturi
	output	[2:0] rgb_o,
	input	[8:0] rgb_1,
	input	[9:0] rgb_2,
);

Modificare de 
culoare  
0 → 1, 1 → 2, 2 → 4, 
3 → 3, 4 → 0, 5 → 6, 
6 → 7, 7 → 5

endmodule



function real Modificare(rgb_i);
begin
  case (rgb_i)
    3'b000 : rgb_i = 3'b001;
    3'b001 : rgb_i = 3'b010;
    3'b010 : rgb_i = 3'b100;
    3'b011 : rgb_i = 3'b011;
    3'b100 : rgb_i = 3'b000;
    3'b101 : rgb_i = 3'b110;
    3'b110 : rgb_i = 3'b111;
    3'b111 : rgb_i = 3'b101;
  endcase
end 
endfunction
localparam rgb = Modificare(row_i)


*/