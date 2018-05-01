//Engine Accuracy
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
module engine_accuracy( input clk,
      input rst,
      input [2:0] wins,
       input collision_detected, // to start the battle
       input [1:0] player_choice, // to choose attack type
       input [1:0] enemy_choice,
       input  player_turn,//it's decided based on the input keys 
       input  attacker_turn,
       input boss, // do we have any?
       input [2:0] level,
       input battle_start,//? do we need this, is equal to collision detected
       output reg [7:0] player_HP, //player's health condition to be shown on the monitor
       output reg [7:0] enemy_HP,
       output reg [1:0] player_remained_sword,//punchs and kicks are infinite 
       output reg [1:0] player_remained_baseballbat,//needed to be shown on the screen
       output reg [1:0] enemy_remained_sword,
       output reg [1:0] enemy_remained_baseballbat,
       output reg player_win,
       output reg enemy_win
    );

parameter P=2'b00, K=2'b01, B=2'b10, S=2'b11;
reg [2:0] accuracy;
reg [26:0] counter;
reg control;
///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////These initial numbers can be changed/////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
initial
begin
player_HP = 8'd100;
enemy_HP = 8'd100;
accuracy = 3'd0;
counter = 27'd0;
end

initial
begin 
player_remained_sword = 2'd3;
player_remained_baseballbat = 2'd3;
enemy_remained_sword = 2'd3;
enemy_remained_baseballbat = 2'd3;
end

//Strength levels should have overlap to to prevent the attackers from using different attack types in their power order
always @(posedge clk)
begin
  if (accuracy <= 3'd7)
   accuracy = accuracy + 3'd1;
  else
   accuracy = 3'd0;
 
 if (rst == 1'b1) begin
  enemy_win = 1'b0;
  player_win = 1'b0;
  player_HP = 8'd100;
  enemy_HP = 8'd100;
 end
 else begin
  
  if (battle_start == 1'b1) begin
    if (level == 3'b000) begin
    player_HP = 8'd100;
    enemy_HP = 8'd100;
   end
   else if (level == 3'b001) begin
    player_HP = 8'd100;
    enemy_HP = 8'd110;
   end
   else if (level == 3'b010) begin
    player_HP = 8'd100;
    enemy_HP = 8'd120;
   end
   else if (level == 3'b011) begin
    player_HP = 8'd100;
    enemy_HP = 8'd130;
   end
   else if (level == 3'b100) begin
    player_HP = 8'd190;
    enemy_HP = 8'd190; //Boss HP
   end
    
   player_remained_sword = 2'd2;
   player_remained_baseballbat = 2'd3;
   enemy_remained_sword = 2'd2;
   enemy_remained_baseballbat = 2'd3;
  end
  
  else if(collision_detected == 1'b0) begin
   if(enemy_HP == 0) begin
    player_win = 1'b0;
    enemy_HP = 8'd100;
   end
  end
  else if (collision_detected == 1) begin
    
   if (player_HP == 0)
    enemy_win = 1'b1;
   else if (enemy_HP == 0) begin
//    if(control == 0) begin
     player_win = 1'b1;
//     control = 1'b1;
//    end
//    else begin
//     player_win = 1'b0;
//     control = 1'b0;
//    end
   end
   else begin
    enemy_win = 1'b0;
    player_win = 1'b0;
   end
   
   if (player_turn == 1) begin
   case (player_choice)
   
    P: begin
     if (accuracy > 4'd0) begin
      if (enemy_HP <= 8'd10)
       enemy_HP = 8'd0;
      else
       enemy_HP = enemy_HP - 8'd10;  //10 HP
     end  
    end
    
    K:begin
      if (accuracy > 4'd1) begin
      if (enemy_HP <= 8'd20)
       enemy_HP = 8'd0;
      else
       enemy_HP = enemy_HP - 8'd20; //20 HP  
     end
    end
    
    B:begin
     if (player_remained_baseballbat > 0)
     begin
      if (accuracy > 4'd2) begin
       if (enemy_HP <= 8'd30)
        enemy_HP = 8'd0;
       else
        enemy_HP = enemy_HP - 8'd30; //30 HP
       end
      player_remained_baseballbat = player_remained_baseballbat - 2'd1;
     end
    end
    
    S:begin
     if (player_remained_sword > 0) begin
      if (accuracy > 4'd3) begin
       if (enemy_HP <= 8'd40)
        enemy_HP = 8'd0;
       else
        enemy_HP = enemy_HP - 8'd40; //40 HP  
      end
      player_remained_sword = player_remained_sword - 2'd1;
     end
    end
    endcase
  end
  
  else if (attacker_turn == 1) begin
   
   case (enemy_choice)
   
    P: begin
     if (accuracy > 4'd0) begin
      if (player_HP <= 8'd10)
       player_HP = 8'd0;
      else
       player_HP = player_HP - 8'd10; // 10 HP
      end
     end
    
    K:begin
     if (accuracy > 4'd1) begin
       if (player_HP <= 8'd20)
       player_HP = 8'd0;
      else
       player_HP = player_HP - 8'd20; // 20 HP
      end
     end
    
    B:begin
     if (enemy_remained_baseballbat > 0)
     begin
     if (accuracy > 4'd2) begin
      if (player_HP <= 8'd30)
       player_HP = 8'd0;
      else
       player_HP = player_HP - 8'd30; //30 HP
      end
      enemy_remained_baseballbat = enemy_remained_baseballbat - 2'd1;
     end
    end
    
    S:begin
     if (enemy_remained_sword > 0) begin
      if (accuracy > 4'd3) begin
       if (player_HP <= 8'd40)
        player_HP = 8'd0;
       else
        player_HP = player_HP - 8'd40; //40HP
      end
     enemy_remained_sword = enemy_remained_sword - 2'd1;
     end
    end
   endcase
  end
end 
end
end
///////////////////////////////////////////////////////////////////////////////////////////////////
endmodule