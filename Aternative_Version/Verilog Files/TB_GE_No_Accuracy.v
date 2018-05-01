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
	wire [7:0] player_HP;
	wire [7:0] enemy_HP;
	wire [4:0] player_remained_sword;
	wire [4:0] player_remained_baseballbat;
	wire [4:0] enemy_remained_sword;
	wire [4:0] enemy_remained_baseballbat;
	wire player_win;
	wire enemy_win;

	// Instantiate the Unit Under Test (UUT)
	new_game uut (
		.clk(clk), 
		.collision_detected(collision_detected), 
		.player_choice(player_choice), 
		.enemy_choice(enemy_choice), 
		.player_turn(player_turn), 
		.attacker_turn(attacker_turn), 
		.player_HP(player_HP), 
		.enemy_HP(enemy_HP), 
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
		#5;
        player_choice = 2'b11;
		  collision_detected = 1;
		#2;
		  player_turn = 1;
		// Add stimulus here
		
		#5;
			player_turn = 0;
			attacker_turn = 1;
			enemy_choice = 2'b10;
		#7;
			player_turn = 1;
			attacker_turn = 0;
			player_choice = 2'b01;
		#2;
			player_turn = 0;
			attacker_turn = 1;
			enemy_choice = 2'b00;
		#4;
			collision_detected = 0;
			attacker_turn = 0;
		#2;
			collision_detected = 1;
		#2;
			player_turn = 1;
		#4;
			player_turn = 0;
			attacker_turn = 1;
		#6;
		$finish;
	end
	
	always 
	#1 clk = !clk;
      
endmodule