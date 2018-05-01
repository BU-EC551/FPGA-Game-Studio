`timescale 1ns / 1ps

module Sprite_Sel(
	input clk,
	input [3:0] inputs,
	input [1:0] step,
	output reg [8:0] hoffset,
	output reg [8:0] voffset
   );
	wire have_inputs;
	reg walk = 0;
	assign have_inputs = (inputs == 8 || inputs == 4 || inputs == 2 || inputs == 1);
	initial begin
		hoffset <= 0;
		voffset <= 0;
	end
	always@(posedge clk) begin
		case(inputs)
			4'b1000: voffset <= 16;// up
			4'b0100: voffset <= 0; // down
			4'b0010: voffset <= 32; //left
			4'b0001: voffset <= 48; //right
			4'b0000: voffset <= voffset;
			default: voffset <= voffset;
		endcase
	end
	always@(step) begin
		hoffset <= have_inputs == 1'b0 ? 1'b0 : step % 2 == 1'b0 ? 1'b0 : (voffset == 32 || voffset == 48) ? 16 : step == 3 ? 32 : 16;
		walk = step == 1'b1 ? walk + 1'b1 : walk;
	end
endmodule
