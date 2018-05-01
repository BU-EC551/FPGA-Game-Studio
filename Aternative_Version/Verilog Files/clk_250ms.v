`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:21:29 04/23/2018 
// Design Name: 
// Module Name:    clk_250ms 
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
module clk_250ms(clk,clk_0);

input clk;
output reg clk_0 = 0;

reg [32:0] k = 0;

always@(posedge clk) begin
	if(k == 1875000) begin
		k <= 0;
		clk_0 = ~clk_0;
	end
	else begin
		k <= k + 1;
	end
end

endmodule
