`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:57 04/22/2018 
// Design Name: 
// Module Name:    win_count 
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
module win_count(
						input rst,
						input win,
						output reg [7:0] wins,
						output reg level_up
						);
initial begin
	wins = 8'h00;
	level_up = 1'b0;
end

always @(posedge win) begin
	if (rst == 1'b1)
		wins = 8'h00;
	else if (wins < 8'hFF)
		wins = wins + 8'h01;
	if (wins >= 8'h05)
		level_up = 1'b1;
	else
		level_up = 1'b0;
end

endmodule
