  
`timescale 1ns / 1ps    
        
 module start_screen(    
	  input clk,    
	  input rst,
	  input [6:0] switch,
	  output reg [2:0] r,    
	  output reg [2:0] g,    
	  output reg [1:0] b,    
	  output hs,    
	  output vs    
	  );    
	  
	  parameter UP_BOUND = 31;    
	  parameter DOWN_BOUND = 510;    
	  parameter LEFT_BOUND = 144;    
	  parameter RIGHT_BOUND = 783;    
	  
	  parameter TITLE = "RPG ESCAPE";
	  reg [79:0] title = TITLE;
	  
	  reg h_speed, v_speed;    
	  reg [9:0] up_pos, down_pos, left_pos, right_pos;    
	  
	  wire pclk;    
	  reg [1:0] count;		  
	  reg [9:0] hcount, vcount;    
			
	  reg [79:0] screen [29:0];
	  assign pclk = count[1];    
	  
	  wire [0:7] data;
	  wire [7:0] grass;
	  wire [10:0] v_offset, h_offset, char_xoffset,char_yoffset;
	  assign v_offset = (vcount - 31) % 16;
	  assign h_offset = (hcount - 144) % 8;
	  assign char_xoffset = (hcount - 144) / 8 - 35;
	  assign char_yoffset = (vcount - 31) / 16 - 9;
	  wire [7:0] char;
	  assign char = char_yoffset != 0 ?	 8'b0: 
						 char_xoffset == 9 ? title[7:0] : 
						 char_xoffset == 8 ? title[15:8] : 
						 char_xoffset == 7 ? title[23:16] : 
						 char_xoffset == 6 ? title[31:24] : 
						 char_xoffset == 5 ? title[39:32] : 
						 char_xoffset == 4 ? title[47:40] : 
						 char_xoffset == 3 ? title[55:48] : 
						 char_xoffset == 2 ? title[63:56] : 
						 char_xoffset == 1 ? title[71:64] : 
						 char_xoffset == 0 ? title[79:72] : 8'b0;
 	  
	  font_rom f0(char*16 + v_offset, data);
	  Grass grass0 (
		  .clka(pclk), // input clka
		  .addra((vcount%8) * 8 + hcount%8), // input [5 : 0] addra
		  .douta(grass) // output [7 : 0] douta
		);
	  always @ (posedge clk)    
	  begin    
			if (rst)    
				 count <= 0;    
			else    
				 count <= count + 1'b1;    
	  end    
			
	  assign hs = (hcount < 96) ? 1'b0 : 1'b1;    
	  always @ (posedge pclk or posedge rst)    
	  begin    
			if (rst)    
				 hcount <= 0;    
			else if (hcount == 799)    
				 hcount <= 0;    
			else    
				 hcount <= hcount + 1'b1;    
	  end    

	  assign vs = (vcount < 2) ? 1'b0 : 1'b1;    
	  always @ (posedge pclk or posedge rst)    
	  begin    
			if (rst)    
				 vcount <= 0;    
			else if (hcount == 799) begin    
				 if (vcount == 520)    
					  vcount <= 0;    
				 else    
					  vcount <= vcount + 1'b1;    
			end    
			else    
				 vcount <= vcount;    
	  end    
			

	  always @ (posedge pclk or posedge rst)    
	  begin    
			if (rst) begin    
				 r <= 3'b000;    
				 g <= 3'b000;    
				 b <= 2'b00;    
			end    
			else begin    
				 if (vcount>=31 && vcount<=510    
							&& hcount>=144 && hcount<=783) begin   
					  if (char_xoffset>=0 && char_xoffset<=9    
							&& char_yoffset == 0) begin 
						  if(data[h_offset]) begin
							  r <= 3'b000;    
							  g <= 3'b000;    
							  b <= 2'b11;  
						  end
						  else begin    
							  r <= grass[7:5];    
							  g <= grass[4:2];    
							  b <= grass[1:0];    
						  end
					  end
					  else begin
							  r <= grass[7:5];    
							  g <= grass[4:2];    
							  b <= grass[1:0]; 
					  end
				 end    
				 else begin    
					  r <= 3'b000;    
					  g <= 3'b000;    
					  b <= 2'b00;    
				 end    
			end    
	  end    
 
	  
 endmodule    
