`timescale 1ns / 1ps

module WallCollisionDetection(position, pblockposx1, pblockposy1, pblockposx2, pblockposy2, pblockposx3, pblockposy3, pblockposx4, pblockposy4);

	input [19:0] position;
	
	output [5:0] pblockposx1, pblockposy1, pblockposx2, pblockposy2, pblockposx3, pblockposy3, pblockposx4, pblockposy4;
	
	/*
		xpos <= position[19:10];
		ypos <= position[9:0];
	*/
	
	//up
	assign pblockposx1 = (position[19:10] - 10'd144)/10'd32;
	assign pblockposy1 = (position[9:0] - 10'd31 - 5'd2)/10'd32;
	
	//right
	assign pblockposx2 = (position[19:10] - 10'd144 + 10'd16 + 5'd2)/10'd32;
	assign pblockposy2 = (position[9:0] - 10'd31)/10'd32;
	
	//down
	assign pblockposx3 = (position[19:10] - 10'd144)/10'd32;
	assign pblockposy3 = (position[9:0] - 10'd31 + 10'd16 + 5'd2)/10'd32;
	
	//left
	assign pblockposx4 = (position[19:10] - 10'd144 - 5'd2)/10'd32;
	assign pblockposy4 = (position[9:0] - 10'd31)/10'd32;
	
endmodule
