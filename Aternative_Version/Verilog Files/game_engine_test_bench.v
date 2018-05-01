`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:09:16 04/20/2018
// Design Name:   game_engin
// Module Name:   X:/Desktop/RPG_GAME_FPGA-master/RPG_GAME_FPGA-master/RPG/TB_gameengine.v
// Project Name:  RPG
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: game_engin
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_gameengine;

	// Inputs
	reg clk;
	reg collision_detected;
	reg [1:0] player_choice;
	reg [1:0] enemy_choice;
	reg player_turn;
	reg attacker_turn;

	// Outputs
	wire [7:0] player_HB;
	wire [7:0] enemy_HB;
	wire [4:0] player_remained_sword;
	wire [4:0] player_remained_baseballbat;
	wire [4:0] enemy_remained_sword;
	wire [4:0] enemy_remained_baseballbat;
	wire player_win;
	wire enemy_win;

	// Instantiate the Unit Under Test (UUT)
	game_engin uut (
		.clk(clk), 
		.collision_detected(collision_detected), 
		.player_choice(player_choice), 
		.enemy_choice(enemy_choice), 
		.player_turn(player_turn), 
		.attacker_turn(attacker_turn), 
		.player_HB(player_HB), 
		.enemy_HB(enemy_HB), 
		.player_remained_sword(player_remained_sword), 
		.player_remained_baseballbat(player_remained_baseballbat), 
		.enemy_remained_sword(enemy_remained_sword), 
		.enemy_remained_baseballbat(enemy_remained_baseballbat), 
		.player_win(player_win), 
		.enemy_win(enemy_win)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		collision_detected = 0;
		player_choice = 0;
		enemy_choice = 0;
		player_turn = 0;
		attacker_turn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        player_choice = 2'b11;
		  collision_detected = 1;
		  player_turn = 1;
		// Add stimulus here
		
		#100
			enemy_choice = 1;
			enemy_choice = 2'b10;
	end
	
	always 
	#5 clk = !clk;
      
endmodule

