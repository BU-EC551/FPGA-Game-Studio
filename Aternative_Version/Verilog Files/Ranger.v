`timescale 1ns / 1ps

module Ranger(
	input clk,
	input [3:0] inputs,
	output [19:0] position
    );
	reg [9:0] a_hpos = 263;
   reg [9:0] a_vpos = 170;  
	assign position = {a_hpos,a_vpos};
	always@(posedge clk) begin
		case(inputs)
			4'b1000: a_vpos <= a_vpos - 5; // up
			4'b0100: a_vpos <= a_vpos + 5; // down
			4'b0010: a_hpos <= a_hpos - 5; //left
			4'b0001: a_hpos <= a_hpos + 5; //right
		endcase
	end
endmodule