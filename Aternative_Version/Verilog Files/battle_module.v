`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:41 04/19/2018 
// Design Name: 
// Module Name:    battle_module 
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
module battle_module(
    input clk_b,
    input col_e,
	 input boss,
	 input [6:0] player_hit,
	 input [7:0] enemy_hit,
    input [7:0] key_in,
    output reg [7:0] HP_player,
    output reg [7:0] HP_enemy,
    output [2:0] p_attack,
    output [2:0] e_attack
    );
	 reg clk;
	 reg [3:0] a_pos_neg;
	 reg [3:0] accuracy;
	 reg [6:0] enemy_ran;
	 reg boss_check;
initial
begin
HP_player = 7'd100;  //100 HP player

enemy_ran = $random%50;
if (enemy_ran > 8'd50)
enemy_ran = ~enemy_ran + 8'h01;

HP_enemy = enemy_ran + 8'd51;

boss_check = 1'b1;
end

always @(posedge clk_b)
begin

//Boss or Enemy?
if (boss == 1'b1 && boss_check == 1'b1) begin
HP_enemy = 8'd150;  //150 HP Boss
boss_check = 1'b0;
end


end
endmodule
