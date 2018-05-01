`timescale 1ns / 1ps
module BtoD(
	input [7:0] B,
	output [8:0] D
    );
	assign D[8] = B >= 100 ? 1 : 0;
	assign D[7:4] = B >= 100 ? 4'h0 : B / 10;
	assign D[3:0] = B >= 100 ? 4'h0 : B % 10;


endmodule
