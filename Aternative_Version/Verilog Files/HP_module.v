`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:34:11 04/20/2018 
// Design Name: 
// Module Name:    HP_module 

// Connect this Module to a battle module to test this. If the proper enable is active, an attack is executed, otherwise it is not.

//
//////////////////////////////////////////////////////////////////////////////////
module HP_module(
	 input clk,
         input [1:0] attack_p,
    	 input [1:0] attack_e,
	 input att_e_en,
	 input att_p_en,
    output reg [7:0] HP_p,
    output reg [7:0] HP_e,
	 output reg HP_p_en,
	 output reg HP_e_en
    );
//accuracy
reg [3:0] a_pos_neg;
reg [3:0] accuracy;
always @(posedge clk, negedge clk) begin
	a_pos_neg = $random%10;
	if (a_pos_neg < 4'd10)
		accuracy = a_pos_neg;
	else
		accuracy = ~a_pos_neg + 7'h01;
end

//random variation between -20% and 20%
reg [7:0] pun_var, kick_var, bat_var, sword_var; 
//HP Deduction
always @(posedge clk) begin
	pun_var = $random%3;
	kick_var = $random%5;
	bat_var = $random%7;
	sword_var = $random%9;
	
	if (att_e_en == 1'b1) begin

		HP_e_en = 1'b1;

		case (attack_e)
			2'b00: begin
			if (accuracy > 4'd0) begin
				if (pun_var > 8'h02)
					HP_e = 8'd10 - (~pun_var + 1);
				else
					HP_e = 8'd10 + pun_var; // 8-12
			end
			else
				HP_e = 8'd0;
			end
			
			2'b01: begin
			if (accuracy > 4'd1) begin
				if (kick_var > 8'h04)
					HP_e = 8'd20 - (~kick_var + 1);
				else
					HP_e = 8'd20 + kick_var; // 16-24
			end
			else
				HP_e = 8'd0;
			end
			
			2'b10: begin
			if (accuracy > 4'd2) begin
				if (bat_var > 8'h06)
					HP_e = 8'd30 - (~bat_var + 1);
				else
					HP_e = 8'd30 + bat_var; // 24-36
			end
			else
				HP_e = 8'd0;
			end
			
			2'b11: begin
			if (accuracy > 4'd3) begin
				if (sword_var > 8'h08)
					HP_e = 8'd40 - (~sword_var + 1);
				else
					HP_e = 8'd40 + sword_var; // 32-48
				end
			else
				HP_e = 8'd0;
			end
		endcase
		end

	if (att_p_en == 1'b1) begin
		
		HP_p_en = 1'b1;

		case (attack_p)
			2'b00: begin
			if (accuracy > 4'd0) begin
				if (pun_var > 8'h02)
					HP_p = 8'd10 - (~pun_var + 1); // 8-12
				else
					HP_p = 8'd10 + pun_var;
			end
			else
				HP_p = 8'd0;
			end
			
			2'b01: begin
			if (accuracy > 4'd1) begin
				if (kick_var > 8'h04)
					HP_p = 8'd20 - (~kick_var + 1); // 16-24
				else
					HP_p = 8'd20 + kick_var;
			end
			else
				HP_p = 8'd0;
			end
			
			2'b10: begin
			if (accuracy > 4'd2) begin
				if (bat_var > 8'h06)
					HP_p = 8'd30 - (~bat_var + 1); // 24-36
				else
					HP_p = 8'd30 + bat_var;
			end
			else
				HP_p = 8'd0;
			end
			
			2'b11: begin
			if (accuracy > 4'd3) begin
				if (sword_var > 8'h08)
					HP_p = 8'd40 - (~sword_var + 1); // 32-48
				else
					HP_p = 8'd40 + sword_var;
			end
			else
				HP_p = 8'd0;
			end
		endcase
		end	
		
		if (att_p_en == 1'b0) begin
		HP_p_en = 1'b0;
		HP_p = 8'd0;
		end
		
		if (att_e_en == 1'b0) begin
		HP_e_en = 1'b0;
		HP_e = 8'd0;
		end
end
endmodule
