`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:40:37 04/19/2018
// Design Name:   collisionDetection
// Module Name:   X:/Desktop/EC 551 Labs/FinalProject/RPG_GAME_FPGA-master/RPG/tb_collisionDetection.v
// Project Name:  RPG
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: collisionDetection
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_collisionDetection;

	// Inputs
	reg [19:0] position;
	reg [19:0] e_position;

	// Outputs
	wire [5:0] pblockposx, pblockposy;
	wire enemyCollide;
	wire wallCollide;

	// Instantiate the Unit Under Test (UUT)
	collisionDetection uut (
		.position(position), 
		.e_position(e_position), 
		.pblockposx(pblockposx), 
		.pblockposy(pblockposy), 
		.enemyCollide(enemyCollide), 
		.wallCollide(wallCollide)
	);

	initial begin
		// Initialize Inputs
		position = 0;
		e_position = 0;
		// Wait 100 ns for global reset to finish
		
		//Sanity Check (100,100) vs (200, 200)
		#10;
      position[19:10] = 10'd100;
		position[9:0] = 10'd100;

		e_position[19:10] = 10'd200;
		e_position[9:0] = 10'd200;
		
		//RIGHT CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is directly to the right, second collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd125;
		e_position[9:0] = 10'd120;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		
		//DOWN CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is directly down, third collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd120;
		e_position[9:0] = 10'd125;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		
		//RIGHT AND DOWN CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is down and right, fourth collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd125;
		e_position[9:0] = 10'd125;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		
		//LEFT CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is directly left, fifth collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd115;
		e_position[9:0] = 10'd120;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		//LEFT AND DOWN CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is downa and left, sixth collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd115;
		e_position[9:0] = 10'd125;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		
		//UP CHECK 
		//Player is at position (120, 120), occupies space until (136, 136), enemy is directly up, seventh collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd120;
		e_position[9:0] = 10'd115;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		//LEFT AND UP CHECK 
		//Player is at position (120, 120), occupies space until (136, 136), enemy is left and up, eigth collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd115;
		e_position[9:0] = 10'd115;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		//EDGE CASE CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is left and up, no collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd137;
		e_position[9:0] = 10'd137;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		//EDGE CASE CHECK
		//Player is at position (120, 120), occupies space until (136, 136), enemy is left and up, ninth collision detected
		#10;
      position[19:10] = 10'd120;
		position[9:0] = 10'd120;

		e_position[19:10] = 10'd136;
		e_position[9:0] = 10'd136;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		//WALL COLLISION CHECK
		//Player is at position (48, 20), wallCollision should be low
		#10;
      position[19:10] = 10'd48;
		position[9:0] = 10'd20;

		e_position[19:10] = 10'd136;
		e_position[9:0] = 10'd136;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;
		
		
		//WALL COLLISION CHECK 2
		//Player is at position (128, 32), wallCollision should be low
		#10;
      position[19:10] = 10'd128;
		position[9:0] = 10'd32;

		e_position[19:10] = 10'd136;
		e_position[9:0] = 10'd136;
		
		//Reset player position to origin to reset collide, no collision
		#10;
      position[19:10] = 10'd0;
		position[9:0] = 10'd0;

	end
      
endmodule

