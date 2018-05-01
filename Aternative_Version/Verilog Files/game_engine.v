`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:04:00 03/24/2018 
// Design Name: 
// Module Name:    game_engin 
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
module game_engin( input clk,
						 input collision_detected, // to start the battle
						 input [1:0] player_choice, // to choose attack type
						 input [1:0] enemy_choice,
						 input  player_turn,//it's decided based on the input keys 
						 input  attacker_turn,
						 output reg [7:0] player_HB, //player's health condition to be shown on the monitor
						 output reg [7:0] enemy_HB,
						 output reg [4:0] player_remained_sword,//punchs and kicks are infinite 
						 output reg [4:0] player_remained_baseballbat,//needed to be shown on the screen
						 output reg [4:0] enemy_remained_sword,
						 output reg [4:0] enemy_remained_baseballbat,
						 output reg player_win,
						 output reg enemy_win
    );


parameter P=2'b00, K=2'b01, S=2'b10, B=2'b11;
reg [7:0] pun_var, kick_var, bat_var, sword_var; 
///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////These initial numbers can be changed/////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

initial
begin
player_HB = 8'd100;
enemy_HB = 8'd100;
end


initial
begin 
player_remained_sword = 5'd4;
player_remained_baseballbat = 5'd3;

enemy_remained_sword = 5'd4;
enemy_remained_baseballbat = 5'd3;
end

//Full Health Bar is 100
//We need to deciede on these numbers
//assign Punch_Accuracy = 100; 
//assign Puch_Power = 5; 
//assign Kick_Accuracy = 80;
//assign Kick_Power = 10;
//assign Sword_Accuracy = 40;
//assign Sword_Power = 20;
//assign BaseballBat_Accuracy = 30;
//assign BaseballBat_Power = 40;

//Strength levels should have overlap to to prevent the attackers from using different attack types in their power order



///////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk)
begin


pun_var = $random%3;
kick_var = $random%5;
bat_var = $random%7;
sword_var = $random%9;
	
if (player_HB == 0)
		enemy_win = 1'b1;
else if (enemy_HB == 0)
		player_win = 1'b1;
end
///////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk)
begin
if(collision_detected == 1)
begin
if (player_turn == 1)
begin
		case (player_choice)
		
			P: begin
				
					if (pun_var > 8'h02)
						enemy_HB = enemy_HB - ( 8'd10 - (~pun_var + 1));
					else
						enemy_HB = enemy_HB -( 8'd10 + pun_var); // 8-12
			end
			K:begin
					if (bat_var > 8'h06)
						enemy_HB = enemy_HB -( 8'd30 - (~bat_var + 1));
					else
						enemy_HB = enemy_HB - (8'd30 + bat_var); // 24-36

			end
			S:begin
				if (player_remained_sword > 0)
				begin
					if (sword_var > 8'h08)
						enemy_HB = enemy_HB -( 8'd40 - (~sword_var + 1));
					else
						enemy_HB = enemy_HB - ( 8'd40 + sword_var); // 32-48
					player_remained_sword = player_remained_sword - 1;
					
				end
			end
			
			B:begin
				if (player_remained_baseballbat > 0)
				begin
					if (sword_var > 8'h08)
						enemy_HB = enemy_HB -( 8'd40 - (~sword_var + 1));
					else
						enemy_HB = enemy_HB - ( 8'd40 + sword_var); // 32-48
				end
					player_remained_baseballbat = player_remained_baseballbat - 1;

				end
		endcase
end
end
end
//////////////////////////////////////some parts of the previous always block should be added here/////////////////////
always @(posedge clk)
begin
if(collision_detected == 1)
begin
if (attacker_turn == 1)
begin
		case (enemy_choice)
		
			P: begin
					if (pun_var > 8'h02)
						player_HB = player_HB - ( 8'd10 - (~pun_var + 1));
					else
						player_HB = player_HB -( 8'd10 + pun_var); // 8-12
					 
			end
			K:begin
			
					if (bat_var > 8'h06)
						player_HB = player_HB -( 8'd30 - (~bat_var + 1));
					else
						player_HB = player_HB - (8'd30 + bat_var); // 24-36
				
			end
			S:begin
				if (enemy_remained_sword > 0)
				begin
					if (sword_var > 8'h08)
						player_HB = player_HB - ( 8'd40 - (~sword_var + 1));
					else
						player_HB = player_HB - ( 8'd40 + sword_var); // 32-48
					enemy_remained_sword = enemy_remained_sword - 1;
					
				end
			end
			
			B:begin
				if (enemy_remained_baseballbat > 0)
				begin
					if (sword_var > 8'h08)
						player_HB = player_HB -( 8'd40 - (~sword_var + 1));
					else
						player_HB = player_HB - ( 8'd40 + sword_var); // 32-48
				end
					enemy_remained_baseballbat = enemy_remained_baseballbat - 1;

				end
		endcase
end
end
end
///////////////////////////////////////////////////////////////////////////////////////////////////

endmodule

