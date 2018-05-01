`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:28:13 04/23/2018 
// Design Name: 
// Module Name:    Escape_Top 
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
module Escape_Top( input clk,
						 input rst,
						 input key_clk,
						 input key_data,
						 output reg [2:0] r,    
						 output reg [2:0] g,    
						 output reg [1:0] b,
						 output hs,    
						 output vs   
    );

wire [7:0] key_out; //key pressed
reg [1:0] p_c, e_c; //choice of player and enemy
wire [7:0] win_count; //number of wins by the player (255 max)
wire p_win, game_over; //Win and Lose
wire l_u, boss; //level up and boss
wire p_HP, e_HP; // HP of player and enemy
wire player_remained_sword, enemy_remained_sword, player_remained_baseballbat, enemy_remained_baseballbat; //PP of bat and sword
wire battle_start; //battle start
wire p_turn, e_turn; // player and enemy turn
wire collision_detected; //collision detected

// Instantiation of game_engine module
engine_accuracy game_engine (
    .clk(clk), 
    .rst(rst), 
    .collision_detected(collision_detected), 
    .player_choice(p_c), 
    .enemy_choice(e_c), 
    .player_turn(p_turn), 
    .attacker_turn(e_turn), 
    .level_up(l_u), 
    .boss(boss), 
    .battle_start(battle_start), 
    .player_HP(p_HP), 
    .enemy_HP(e_HP), 
    .player_remained_sword(player_remained_sword), 
    .player_remained_baseballbat(player_remained_baseballbat), 
    .enemy_remained_sword(enemy_remained_sword), 
    .enemy_remained_baseballbat(enemy_remained_baseballbat), 
    .player_win(p_win), 
    .enemy_win(game_over)
    );

//instantiation of vga
vga_controller vga(    
        .clk(clk),   
		  .keyclk(key_clk),		  
		  .keyinput(key_data),
        .rst(rst),
		  .left(),
		  .right(),
		  .up(),
		  .down(),
        .r(r),    
        .g(g),    
        .b(b),
		  .led(key_out),
        .hs(hs),    
        .vs(vs)    
        );    
// win counter
module win_count(
						.rst(rst),
						.win(p_win),
						.wins(win_count),
						.level_up(l_u)
						);

parameter  PP=8'h1C, PK=8'h1B, PB=8'h23, PS=8'h1D, EP=8'h3B, EK=8'h42, EB=8'h4B, ES=8'h43;

always @(posedge clk) begin
	case (key_out)
	//Player's attacks
		PP: p_c = 2'b00; //Punch
		PK: p_c = 2'b01; //Kick
		PB: p_c = 2'b10; //Bat
		PS: p_c = 2'b11; //Sword
		
	//Enemy's attacks
		EP: e_c = 2'b00; //Punch
		EK: e_c = 2'b01; //Kick
		EB: e_c = 2'b10; //Bat
		ES: e_c = 2'b11; //Sword
		
		default: begin end
	endcase
	
	if (collision_detected == 1'b1) begin
		if (p_turn == 1'b1) begin
			p_turn = 1'b0;
			e_turn = 1'b1;
		end
		else begin
			p_turn = 1'b1;
			e_turn = 1'b0;
		end
	end
end
endmodule
