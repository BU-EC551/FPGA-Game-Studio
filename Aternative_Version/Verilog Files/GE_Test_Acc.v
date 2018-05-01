`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:29:05 04/21/2018
// Design Name:   new_game
// Module Name:   /home/ise/game_project/GE_Test_Acc.v
// Project Name:  game_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: new_game
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module GE_Test_Acc;

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
	engine_accuracy uut (
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
	always 
	#1 clk = !clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		collision_detected = 0;
		player_choice = 0;
		enemy_choice = 0;
		player_turn = 0;
		attacker_turn = 0;

		#5;
		collision_detected = 1;
		#5;
		player_turn = 1;
		attacker_turn = 1;
		#20;
		
		collision_detected = 0;
		#5;
		player_turn = 0;
		attacker_turn = 0;
		collision_detected = 1;
		#5;
		
		player_turn = 1;
		attacker_turn = 1;
		#20;
		
		collision_detected = 0;
		#5;
		player_turn = 0;
		attacker_turn = 0;
		collision_detected = 1;
		#5;
		
		player_turn = 1;
		attacker_turn = 1;
		player_choice = 2'b01;
		enemy_choice = 2'b01;
		#10;
		
		collision_detected = 0;
		#5;
		player_turn = 0;
		attacker_turn = 0;
		collision_detected = 1;
		#5;
		player_turn = 1;
		attacker_turn = 1;
		player_choice = 2'b10;
		enemy_choice = 2'b11;
		#10;
		$finish;

	end
      
endmodule

