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
		  output [2:0] wincounter,
        output reg hs,    
        output reg vs,
		  output battleWinControl);


		//Game State
		reg [2:0] gameState = 3'b000;
		reg win = 0;
		reg dead = 0;
		reg [7:0] rst_count = 0;
		reg [2:0] wincounter = 0;
		wire clk_1s;
		wire vga_clk;
		wire battlewin, battledead;
		reg battle_rst = 0;
		assign vga_clk = (enemyCollide && !win) ? 0 : clk;
		
		//Red Select
		wire [2:0] r0, r1, r2, r3, r4, r5, r6;
		
		//Green Select
		wire [2:0] g0, g1, g2, g3, g4, g5, g6;
		
		//Blue Select
		wire [1:0] b0, b1, b2, b3, b4, b5, b6;
		
		//HS Select
		wire hs0, hs1, hs2, hs3, hs4, hs5, hs6;
		
		//VS Select
		wire vs0, vs1, vs2, vs3, vs4, vs5, vs6;
		
		wire enemyCollide, key_break, battleWinControl, bossControl, battlewin1, battledead1;
		reg winGame = 0;
		reg loseBoss = 0;
		wire [7:0] enemyHP, led;
		
//Top level FSM for game state management
//State 0: Start Screen
	//VGA output should be set to start screen VGA
	 start_screen 					s0(clk, rst, switch[6:0], r0, g0, b0, hs0, vs0);
	
//State 1: Maze Screen
	//User inputs are arrow keys
	//VGA is vga.v
	vga_controller					vga1(clk, keyclk, keyinput, rst, r1, g1, b1, led, hs1, vs1, enemyCollide, key_break, battlewin, bossControl);
	
//State 2: Battle State
	//User inputs are A W S D, J K L I for attack select, all others disabled
	 battle_screen 				bs0(clk, keyclk, keyinput, enemyCollide, rst, enemyHP, r2, g2, b2, hs2, vs2, battlewin, battledead);
	
//State 3: Game End State
	battleScreen					ws1(clk, rst, switch[6:0], r3, g3, b3, hs3, vs3);
	
	//Boss Battle
	basic_battle_screen			battle1(clk, clk_1s, rst, led, 3'd5, r4, g4, b4, battlewin1, battledead1, hs4, vs4); 
	
	//Win screen
	win_screen						win1(clk, rst, r5, g5, b5, hs5, vs5); 
	
	//Lose Screen
	lose_screen						lose1(clk, rst, r6, g6, b6, hs6, vs6);
 
	assign battleWinControl = battlewin ? !enemyCollide ? 1'b0 : 1'b1 : 1'b0;
	assign bossControl = winGame;
	
	always @ (posedge battledead1) begin
		loseBoss <= 1'b1;
	end
	always @(posedge battleWinControl) begin
		wincounter = wincounter + 1;
		if (wincounter == 5) begin
			winGame <= 1;
		end
	end
	
	always @ (posedge clk) begin
		case(gameState)
			//Start
			3'b000: begin
						r <= r0;
						g <= g0;
						b <= b0;
						hs <= hs0;
						vs <= vs0;
							if(switch[7]) begin
								gameState <= 3'b001;
							end
							
							else begin
								gameState <= 2'b00;
							end
						
					 end
			//Maze
			3'b001: begin
						r <= r1;
						g <= g1;
						b <= b1;
						hs <= hs1;
						vs <= vs1;
							if(enemyCollide && !battleWinControl) begin
								gameState <= 3'b010;
							end
							
							else if(bossControl && !battleWinControl)
								gameState <= 3'b100;
							
							else begin
								gameState <= 3'b001;
							end
						
					 end
			//Battle
			3'b010: begin
						r <= r2;
						g <= g2;
						b <= b2;
						hs <= hs2;
						vs <= vs2;
							if(battledead) begin
								gameState <= 3'b011;
							end
							
							else if(bossControl) begin
								gameState <= 3'b101;
							end
							
							else if(battleWinControl) begin
								gameState <= 3'b001;
							end
							
							else
								gameState <= 3'b010;
					 end
					 
			//End Screen Lose
			3'b011: begin
						r <= r6;
						g <= g6;
						b <= b6;
						hs <= hs6;
						vs <= vs6;
						end
					 
			//Boss Battle
			3'b100: begin
						r <= r4;
						g <= g4;
						b <= b4;
						hs <= hs4;
						vs <= vs4;
						if(battlewin1)
							gameState <= 3'b101;
						else if(loseBoss)
							gameState <= 3'b011;
						else
							gameState <= 3'b100;
					 end
					 
			//End Screen Win
			3'b101: begin
						r <= r5;
						g <= g5;
						b <= b5;
						hs <= hs5;
						vs <= vs5;
						end
		endcase
		
//		if (battlewin) win <= 1;
//		else if (!enemyCollide) win <= 0;
//		if (battledead) dead <= 1;
////		else if (!enemyCollide) dead <= 0;
//		
//		if (win || dead) begin
//			battle_rst <= 1;
//		end
//		if (battle_rst == 1) begin
//			rst_count = rst_count + 1;
//			if(rst_count[7] == 1) begin
//				battle_rst <= 0;
//				rst_count = 0;
//				dead <= 0;
//			end
//		end
		
	end
endmodule
