`timescale 1ns / 1ps

module Background(clk, clk_1s, h_count, v_count,color);
input clk, clk_1s;
input [9:0] h_count,v_count;
output reg [7:0] color;
wire [7:0] grass, flower, flower_0, flower_1, brick;
reg [3:0] count = 0;

		  

Grass GrassBackground (
  .clka(clk), // input clka
  .addra((v_count%8) * 8 + h_count%8), // input [5 : 0] addra
  .douta(grass) // output [7 : 0] douta
);

assign flower = count[3] == 1 ? flower_0 : flower_1;

flower f0 (
  .clka(clk), // input clka
  .addra(((v_count - 31)%8) * 8 + (h_count - 144)%8), // input [5 : 0] addra
  .douta(flower_0) // output [7 : 0] douta
);

flower f1 (
  .clka(clk), // input clka
  .addra(((v_count - 31)%8) * 8 + (7 - (h_count - 144)%8)), // input [5 : 0] addra
  .douta(flower_1) // output [7 : 0] douta
);

brick b1 (
  .clka(clk), // input clka
  .addra((v_count%16) * 16 + h_count%16), // input [7 : 0] addra
  .douta(brick) // output [7 : 0] douta
);

	//Maze Matrix
	reg [0:299] collisionMatrix = 300'b101111111111111111111000000000001000000111111111111010101101100000100010101001011010101110101010010110101000001010100101101011111110101101011010000010001000010110111110101010100101101000001010001001011010111110101111010110100010001010000101101110111111101011011000100000000010000111111111111111111101;
		  

//        parameter UP_BOUND = 31;    
//        parameter DOWN_BOUND = 510;    
//        parameter LEFT_BOUND = 144;    
//        parameter RIGHT_BOUND = 783; 


 //Maze VGA control signals
 	reg [4:0] matrixXLoc = 5'd0;
	reg [3:0] matrixYLoc = 4'd0;
	
always @ (posedge clk) begin
	matrixXLoc <= (h_count - 144)/7'd32;
	matrixYLoc <= (v_count - 31)/7'd32;

	if(!(v_count >= 31 && v_count <= 510 && h_count >= 144 && h_count <= 783)) begin
		color <= 8'b00000000;
	end
	
	else if(collisionMatrix[matrixYLoc * 20 + matrixXLoc]) begin
		color <= brick;
	end
	
	else begin
		color <= (matrixYLoc >= 7 && matrixYLoc <= 9 && matrixXLoc >= 15 && matrixXLoc <= 16) ? 
					((((v_count - 31)/8)%2 == 1 && ((h_count - 144)/8)%2 == 1) || (((v_count - 31)/8)%2 == 0 && ((h_count - 144)/8)%2 == 0)) ? flower : grass : grass;
	end
end

always@(posedge clk_1s) 
	count = count + 1'b1;
endmodule
