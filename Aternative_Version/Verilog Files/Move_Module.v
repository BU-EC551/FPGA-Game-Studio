`timescale 1ns / 1ps

module Move_Module(
	input [19:0] e_position1,
	input [19:0] e_position2,
	input [19:0] e_position3,
	input [19:0] e_position4,
	input [19:0] e_position5,
	input clk,
	input [3:0] inputs,
	input win,
	output reg enemyCollide,
	output reg [2:0] CON,
	output [19:0] newPosition
    );
	 
//        parameter UP_BOUND = 31;    
//        parameter DOWN_BOUND = 510;    
//        parameter LEFT_BOUND = 144;    
//        parameter RIGHT_BOUND = 783;

	//Initialize Player position here
	reg [9:0] a_hpos = 180;
   reg [9:0] a_vpos = 32; 
	
	assign newPosition = {a_hpos,a_vpos};

	//Collision Detection Signals
	wire [5:0] pblockposx1, pblockposy1, pblockposx2, pblockposy2, pblockposx3, pblockposy3, pblockposx4, pblockposy4;
	wire wallCollide, wallCollide1, wallCollide2, wallCollide3;	
	wire [2:0] enemyCollideWire1, enemyCollideWire2, enemyCollideWire3, enemyCollideWire4, enemyCollideWire5;
	wire anyEnemyUp, anyEnemyDown, anyEnemyLeft, anyEnemyRight;
	
	reg [0:299] collisionMatrix = 300'b101111111111111111111000000000001000000111111111111010101101100000100010101001011010101110101010010110101000001010100101101011111110101101011010000010001000010110111110101010100101101000001010001001011010111110101111010110100010001010000101101110111111101011011000100000000010000111111111111111111101;
		  
	assign wallCollide1 =  collisionMatrix[pblockposy1 * 20 + pblockposx1] ? 1'b1 : 1'b0;
	assign wallCollide2 =  collisionMatrix[pblockposy2 * 20 + pblockposx2] ? 1'b1 : 1'b0;
	assign wallCollide3 =  collisionMatrix[pblockposy3 * 20 + pblockposx3] ? 1'b1 : 1'b0;
	assign wallCollide4 =  collisionMatrix[pblockposy4 * 20 + pblockposx4] ? 1'b1 : 1'b0;
	
	WallCollisionDetection  cd1({a_hpos, a_vpos}, pblockposx1, pblockposy1, pblockposx2, pblockposy2, pblockposx3, pblockposy3, pblockposx4, pblockposy4);
	collisionDetection		cd2({a_hpos, a_vpos}, e_position1, enemyCollideWire1);
	collisionDetection		cd3({a_hpos, a_vpos}, e_position2, enemyCollideWire2);
	collisionDetection		cd4({a_hpos, a_vpos}, e_position3, enemyCollideWire3);
	collisionDetection		cd5({a_hpos, a_vpos}, e_position4, enemyCollideWire4);
	collisionDetection		cd6({a_hpos, a_vpos}, e_position5, enemyCollideWire5);
	
//	assign CON = !win ? 0 : 
//					 enemyCollideWire1 ? 1 : 
//					 enemyCollideWire2 ? 2 : 
//					 enemyCollideWire3 ? 3 : 
//					 enemyCollideWire4 ? 4 : 5;
	
	assign anyEnemyUp    = (enemyCollideWire1 == 3'd1) || (enemyCollideWire2 == 3'd1) || (enemyCollideWire3 == 3'd1) || (enemyCollideWire4 == 3'd1) || (enemyCollideWire5 == 3'd1);
	assign anyEnemyDown  = (enemyCollideWire1 == 3'd2) || (enemyCollideWire2 == 3'd2) || (enemyCollideWire3 == 3'd2) || (enemyCollideWire4 == 3'd2) || (enemyCollideWire5 == 3'd2);
	assign anyEnemyLeft  = (enemyCollideWire1 == 3'd3) || (enemyCollideWire2 == 3'd3) || (enemyCollideWire3 == 3'd3) || (enemyCollideWire4 == 3'd3) || (enemyCollideWire5 == 3'd3);
	assign anyEnemyRight = (enemyCollideWire1 == 3'd4) || (enemyCollideWire2 == 3'd4) || (enemyCollideWire3 == 3'd4) || (enemyCollideWire4 == 3'd4) || (enemyCollideWire5 == 3'd4);
	
//	always@(enemyCollideWire1 or enemyCollideWire2 or enemyCollideWire3 or enemyCollideWire4 or enemyCollideWire5) begin
//		CON <= 	 enemyCollideWire1 ? 1 : 
//					 enemyCollideWire2 ? 2 : 
//					 enemyCollideWire3 ? 3 : 
//					 enemyCollideWire4 ? 4 : 
//					 enemyCollideWire5 ? 5 : CON;
//	end
	
	always@(posedge clk) begin
		//If enemyCollide, then move back to where you were
					 
		case(inputs)
				4'b1000: a_vpos <= wallCollide1 ? a_vpos : anyEnemyUp ? a_vpos  + 3'd2   : a_vpos - 3'd2; // up
				4'b0100: a_vpos <= wallCollide3 ? a_vpos : anyEnemyDown ? a_vpos - 3'd2  : a_vpos + 3'd2; // down
				4'b0010: a_hpos <= wallCollide4 ? a_hpos : anyEnemyLeft ? a_hpos + 3'd2  : a_hpos - 3'd2; //left
				4'b0001: a_hpos <= wallCollide2 ? a_hpos : anyEnemyRight ? a_hpos - 3'd2 : a_hpos + 3'd2; //right
		endcase
		if(anyEnemyUp || anyEnemyDown || anyEnemyLeft || anyEnemyRight) begin
			enemyCollide <= 1'b1;
		end
		
		else begin
			//No enemy collides,
			enemyCollide <= 1'b0;
		end
		
		CON = 	 enemyCollideWire1 ? 1 : 
					 enemyCollideWire2 ? 2 : 
					 enemyCollideWire3 ? 3 : 
					 enemyCollideWire4 ? 4 : 
					 enemyCollideWire5 ? 5 : CON;
	end
endmodule
