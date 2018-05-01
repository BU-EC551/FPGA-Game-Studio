`timescale 1ns / 1ps

module Top_Module(
	  input clk,   
	  input keyclk,		  
	  input keyinput,
	  input rst,
	  input [7:0] switch,
	  output [2:0] r,    
	  output [2:0] g,    
	  output [1:0] b,
	  output [7:0] led,
	  output hs,    
	  output vs   
    );
wire [2:0] r0, g0, r1, g1;
wire [1:0] b0, b1;
wire hs0, hs1, vs0, vs1;

vga_controller v0(clk, keyclk, keyinput, rst, r0, g0, b0, led, hs0, vs0);    
start_screen s0(clk, rst, switch[6:0], r1, g1, b1, hs1, vs1); 

assign 		hs = switch[7] ? hs0 : hs1;
assign		vs = switch[7] ? vs0 : vs1;
assign		r = switch[7] ? r0 : r1;
assign		g = switch[7] ? g0 : g1;
assign		b = switch[7] ? b0 : b1;

endmodule
