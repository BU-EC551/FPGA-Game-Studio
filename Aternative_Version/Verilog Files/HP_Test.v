`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:19:39 04/20/2018
// Design Name:   HP_module
// Module Name:   /home/ise/game_project/HP_test.v
// Project Name:  game_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: HP_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module HP_test;

	// Inputs
	reg clk;
	reg [1:0] attack_p;
	reg [1:0] attack_e;
	reg att_e_en;
	reg att_p_en;

	// Outputs
	wire [7:0] HP_p;
	wire [7:0] HP_e;
	wire HP_p_en;
	wire HP_e_en;
	// Instantiate the Unit Under Test (UUT)
	HP_module uut (
		.clk(clk), 
		.attack_p(attack_p), 
		.attack_e(attack_e), 
		.att_e_en(att_e_en), 
		.att_p_en(att_p_en), 
		.HP_p(HP_p), 
		.HP_e(HP_e), 
		.HP_p_en(HP_p_en), 
		.HP_e_en(HP_e_en)
	);
always begin
 #1 clk = !clk;
 end
	initial begin
		// Initialize Inputs
		clk = 0;
		attack_p = 0;
		attack_e = 0;
		att_e_en = 0;
		att_p_en = 0;

		// Wait 100 ns for global reset to finish
		#5;
		
      att_e_en = 1;
		#10;
		
		att_e_en = 0;
		att_p_en = 1;
		attack_p = 2'b01;
		#10;
		
		att_e_en = 1;
		att_p_en = 0;
		attack_e = 2'b10;
		#10;
		
		att_e_en = 0;
		att_p_en = 1;
		attack_p = 2'b11;
		#10;
		att_e_en = 1;
		#100;
		$finish;
		// Add stimulus here

	end
      
endmodule

