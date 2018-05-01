`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:26 04/23/2018 
// Design Name: 
// Module Name:    GameTop 
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
module GameTop(input clk,   
		  input keyclk,		  
		  input keyinput,
        input rst,
		  input [7:0] switch,
        output reg [2:0] r,    
        output reg [2:0] g,    
        output reg [1:0] b,
		  output [7:0] led,
        output reg hs,    
        output reg vs);


		//Game State
		reg [1:0] gameState = 2'b00;
		reg win = 0;
		reg dead = 0;
		reg [7:0] rst_count = 0;
		reg [2:0] wincounter = 0;
		wire clk_1s;
		wire vga_clk;
		wire battlewin,battledead;
		reg battle_rst = 0;
		assign vga_clk = (enemyCollide && !win) ? 0 : clk;
		
		//Red Select
		wire [2:0] r0, r1, r2, r3;
		
		//Green Select
		wire [2:0] g0, g1, g2, g3;
		
		//Blue Select
		wire [1:0] b0, b1, b2, b3;
		
		//HS Select
		wire hs0, hs1, hs2, hs3;
		
		//VS Select
		wire vs0, vs1, vs2, vs3;
		
		wire [7:0] PHP, EHP;
		reg winGame = 0;
		wire enemyCollide, switchState, switchState0, switchState1, switchState2, switchState3;
		
		assign switchState = (switchState0 || switchState1 || switchState2 || switchState3);
		
		clk_div_1s 						clk_d(clk, clk_1s);
		
		//Direction Control from Keyboard
		Keyboard_PS2 					keyboard(clk, 1, keyclk, keyinput, led, );
		  
//Top level FSM for game state management
//State 0: Start Screen
	//Disable all user input except for "Press Enter to Start"
	//VGA output should be set to start screen VGA

	start_screen 					s0(clk, rst, r0, g0, b0, hs0, vs0);
	
//State 1: Maze Screen
	//User inputs are arrow keys
	//VGA is vga.v
	//wire [7:0] maze_input;
	//assign maze_input = gameState == 2'b01? led : 8'b0; 
	
	vga_controller					vga1(vga_clk, clk_1s, rst, r1, g1, b1, led, win, hs1, vs1, enemyCollide);//, switchState1);
	
//State 2: Battle State
	//User inputs are A W S D, J K L I for attack select, all others disabled
//	battle_screen 				bs0(clk, rst, {PHP, EHP}, r2, g2, b2, hs2, vs2);
	basic_battle_screen 				bs0(clk && (enemyCollide && !(win||dead)), clk_1s, battle_rst, {PHP, EHP}, led, wincounter, r2, g2, b2, battlewin, battledead, hs2, vs2);
	
//State 3: Game End State
	//Press R to Restart
	win_screen 					s1(clk, rst, r3, g3, b3, hs3, vs3);
	
	always @(posedge battlewin) begin
		wincounter = wincounter + 1;
		if (wincounter == 5) begin
			winGame <= 1;
		end
	end
	always @ (posedge clk) begin
		case(gameState)
			2'b00: begin
						r <= r0;
						g <= g0;
						b <= b0;
						hs <= hs0;
						vs <= vs0;
							if(switch[7]) begin
								gameState <= 2'b01;
							end
							
							else begin
								gameState <= 2'b00;
							end
						
					 end
			2'b01: begin
						r <= r1;
						g <= g1;
						b <= b1;
						hs <= hs1;
						vs <= vs1;
							if(enemyCollide) begin
								gameState <= 2'b10;
							end
							
							else begin
								gameState <= 2'b01;
							end
						
					 end
			2'b10: begin
						r <= r2;
						g <= g2;
						b <= b2;
						hs <= hs2;
						vs <= vs2;
							if(winGame) begin
								gameState <= 2'b11;
							end else if (win) begin
								gameState <= 2'b01;
							end
							else if(battledead) begin
								gameState <= 2'b00;
							end
//							else if(switch[7]) begin
//								gameState <= 2'b01;
//							end
					 end
			2'b11: begin
						r <= r3;
						g <= g3;
						b <= b3;
						hs <= hs3;
						vs <= vs3;
						if (switch[7])gameState <= 2'b00;
					 end
		endcase
		
		if (battlewin) win <= 1;
		else if (!enemyCollide) win <= 0;
		if (battledead) dead <= 1;
//		else if (!enemyCollide) dead <= 0;
		
		if (win || dead) begin
			battle_rst <= 1;
		end
		if (battle_rst == 1) begin
			rst_count = rst_count + 1;
			if(rst_count[7] == 1) begin
				battle_rst <= 0;
				rst_count = 0;
				dead <= 0;
			end
		end
	end
endmodule
