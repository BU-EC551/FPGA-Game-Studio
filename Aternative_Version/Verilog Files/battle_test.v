`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:40:16 04/19/2018
// Design Name:   battle_module
// Module Name:   X:/EC551/RPG_GAME_FPGA-master/RPG/ran_test.v
// Project Name:  RPG
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: battle_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module battle_test;

	// Inputs
	reg clk_b;
	reg col_e;
	reg boss;
	reg [7:0] key_in;

	// Outputs
	wire [6:0] HP_player;
	wire [7:0] HP_enemy;
	wire [2:0] p_attack;
	wire [2:0] e_attack;

	// Instantiate the Unit Under Test (UUT)
	battle_module uut (
		.clk_b(clk_b), 
		.col_e(col_e),
		.boss(boss),
		.key_in(key_in), 
		.HP_player(HP_player), 
		.HP_enemy(HP_enemy), 
		.p_attack(p_attack), 
		.e_attack(e_attack) 
	);
always begin
		#1 clk_b = !clk_b;
		end
	initial begin
		// Initialize Inputs
		clk_b = 0;
		col_e = 0;
		key_in = 2'b11;
		boss = 1'b0;
		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here

	end
      
endmodule

