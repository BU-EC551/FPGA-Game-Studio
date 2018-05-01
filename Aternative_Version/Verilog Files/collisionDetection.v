`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:17:46 04/19/2018 
// Design Name: 
// Module Name:    collisionDetection 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module collisionDetection(position, e_position, enemyCollide);

	input [19:0] position;
	input [19:0] e_position;
	
	output reg[2:0] enemyCollide;
	
	/*
		xpos <= position[19:10];
		ypos <= position[9:0];
	*/
	
	initial begin
		enemyCollide = 3'b000;
	end	
	
	//Always at position change
	always @ (position or e_position) begin

	//right collision, checked, works
		//If horizontal collision, enemy to the right
		if(e_position[19:10] - position[19:10] >= 0 && e_position[19:10] - position[19:10] <= 10'd16 ||
			position[19:10] - e_position[19:10] >= 0 && position[19:10] - e_position[19:10] <= 10'd16) begin
		
			//if vertical collision, enemy down, checked, works
			if(e_position[9:0] >= position[9:0] && e_position[9:0] <= position[9:0] + 10'd19) begin
				enemyCollide <= 3'b010;  // down 2
			end
			
			//if vertical collision, enemy up, checked, works
			else if(e_position[9:0] <= position[9:0] && e_position[9:0] + 10'd19 >= position[9:0]) begin
  				enemyCollide <= 3'b001;  // up 1
			end
			
			//No collision
			else
				enemyCollide <= 3'b000;
		end	
		
	//left collision, checked, works
		//If horizontal collision, enemy to the left
		else if(e_position[9:0] - position[9:0] >= 0 && e_position[9:0] - position[9:0] <= 10'd16 ||
			position[9:0] - e_position[9:0] >= 0 && position[9:0] - e_position[9:0] <= 10'd16) begin
		
			//if vertical collision, enemy down, checked, works
			if(e_position[19:10] >= position[19:10] && e_position[19:10] <= position[19:10] + 10'd19) begin
				enemyCollide <= 3'b100;  // right 4
			end
			
			//if vertical collision, enemy up, checked, works
			else if(e_position[19:10] <= position[19:10] && e_position[19:10] + 10'd19 >= position[19:10]) begin
  				enemyCollide <= 3'b011;  // left 3
			end 
			
			//No collision
			else
				enemyCollide <= 3'b000;
		end
		
		else
			enemyCollide <= 3'b000;
	end

endmodule
