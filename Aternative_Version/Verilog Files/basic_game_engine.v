  
`timescale 1ns / 1ps    
        
 module basic_battle_screen(    
	  input clk,   
	  input clk_1s,
	  input rst,
	  input [15:0] HP,
	  input [7:0] led,
	  input [2:0] level,
	  output reg [2:0] r,    
	  output reg [2:0] g,    
	  output reg [1:0] b,    
	  output reg win,
	  output reg dead,
	  output hs,    
	  output vs    
	  );    
	  
//	  parameter UP_BOUND = 31;    
//	  parameter DOWN_BOUND = 510;    
//	  parameter LEFT_BOUND = 144;    
//	  parameter RIGHT_BOUND = 783;    

	  wire pclk, clk_0, enemy_clk; 
	  wire [7:0] grass, wpdouta, AshData, EnemyData, brick, firedata, firedata1;
	  wire [8:0] voffset, hoffset;	  
	  reg [1:0] count, ecount;		  
	  reg [9:0] hcount, vcount;    

	  reg [9:0] a_vpos = 263;
	  reg [9:0] a_hpos = 416;
	  
	  reg [9:0] e_vpos = 263;
	  reg [9:0] e_hpos = 512;
	  
	  reg [9:0] v0 = 0;
	  reg [9:0] h0 = 0;
	  
	  reg [9:0] v1 = 0;
	  reg [9:0] h1 = 0;
	  
	  reg [9:0] v2 = 0;
	  reg [9:0] h2 = 0;
	  
	  reg h_enemy_dir = 0; 
	  reg v_enemy_dir = 0; 
	  reg [1:0] step = 0;
	  
	  reg [2:0] fire_counter = 0;
	  reg random_counter = 0; 
	  reg [9:0] xfire0 = 0;
	  reg [9:0] yfire0 = 0;
	  reg xfire0_d = 0;
	  reg yfire0_d = 0;
	  
	  reg [9:0] xfire1 = 0;
	  reg [9:0] yfire1 = 0;
	  reg xfire1_d = 492;
	  reg yfire1_d = 263;
	  
	  assign pclk = count[1];   
	  assign enemy_clk = ecount[1];
	  clk_250ms							clk2(clk, clk_0);
	  Grass grass0 (
		  .clka(pclk), // input clka
		  .addra((vcount%8) * 8 + hcount%8), // input [5 : 0] addra
		  .douta(grass) // output [7 : 0] douta
		);

	  Ash ash0(
			  .clka(pclk), // input clka
			  .addra(((vcount - a_vpos) % 16 + voffset) * 48 + (hcount - a_hpos + hoffset)), // input [31 : 0] addra
			  .douta(AshData) // output [31 : 0] AshData
			);

	  Enemy rocket0(
			  .clka(pclk), // input clka
			  .addra(((vcount - e_vpos) % 16 + 32) * 48 + (hcount - e_hpos)), // input [31 : 0] addra
			  .douta(EnemyData) // output [31 : 0] AshData
			);
	  
	  brick b0 (
		  .clka(pclk), // input clka
		  .addra((vcount%16) * 16 + hcount%16), // input [7 : 0] addra
		  .douta(brick) // output [7 : 0] douta
		);
	  
	  flower f0 (
		  .clka(pclk), // input clka
		  .addra(((vcount - yfire0)%8) * 8 + (hcount - xfire0)%8), // input [5 : 0] addra
		  .douta(firedata) // output [7 : 0] douta
		);
		
		brick b1 (
		  .clka(pclk), // input clka
		  .addra(((vcount - yfire1)%8) * 8 + (hcount - xfire1)%8), // input [5 : 0] addra
		  .douta(firedata1) // output [7 : 0] douta
		);
	  
	  wire kleft, kright, kup, kdown;
	  assign kleft = led == 8'h6b ? 1'b1 : 1'b0;
	  assign kright = led == 8'h74 ? 1'b1 : 1'b0;
	  assign kup = led == 8'h75 ? 1'b1 : 1'b0;
	  assign kdown = led == 8'h72 ? 1'b1 : 1'b0;	  
	  wire block;
	  assign block = (hcount >= 356 && hcount <=571 && ((vcount >= 337 && vcount <= 344) || (vcount >= 213 && vcount <= 220))) || 
							(vcount >= 221 && vcount <=336 && ((hcount >= 356 && hcount <= 363) || (hcount >= 564 && hcount <= 571)));

	  Sprite_Sel SEL0(pclk, {kup, kdown, kleft, kright}, step, hoffset, voffset);
	  
	  initial begin
			win = 0;
			dead = 0;
	  end
	  
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
						if (vcount>=yfire0 && vcount<=yfire0+7    
							&& hcount>=xfire0 && hcount<=xfire0+7) begin
							r <= firedata[7:5];
							b <= firedata[4:2];
							b <= firedata[1:0];
						end else if (vcount>=yfire1 && vcount<=yfire1+7    
							&& hcount>=xfire1 && hcount<=xfire1+7) begin
								r <= firedata1[7:5];
								b <= firedata1[4:2];
								b <= firedata1[1:0];
							end
						else if (vcount>=a_vpos && vcount<=a_vpos+15    
							&& hcount>=a_hpos && hcount<=a_hpos+15) begin 
							  r <= AshData != 8'hff ? AshData[7:5] : grass[7:5];    
							  g <= AshData != 8'hff ? AshData[4:2] : grass[4:2];    
							  b <= AshData != 8'hff ? AshData[1:0] : grass[1:0];
						end else if (vcount>=e_vpos && vcount<=e_vpos+15    
							&& hcount>=e_hpos && hcount<=e_hpos+15) begin 
							  r <= EnemyData != 8'hff ? EnemyData[7:5] : grass[7:5];    
							  g <= EnemyData != 8'hff ? EnemyData[4:2] : grass[4:2];    
							  b <= EnemyData != 8'hff ? EnemyData[1:0] : grass[1:0];
						end else begin
							  r <= block ? brick[7:5] : grass[7:5];    
							  g <= block ? brick[4:2] : grass[4:2];    
							  b <= block ? brick[1:0] : grass[1:0];
						end
				 end     
				 else begin    
					  r <= 3'b000;    
					  g <= 3'b000;    
					  b <= 2'b00;    
				 end    
			end    
	  end    
	  
	  always@(posedge clk_1s) begin
			if(rst) begin
				xfire0 = 0;
				yfire0 = 0;
				xfire0_d = 0;
				yfire0_d = 0;
				
				xfire1 = 0;
				yfire1 = 0;
				xfire1_d = 1;
				yfire1_d = 1;
				
				fire_counter = 0;
				win = 0;
				dead = 0;

			end else begin
				step = step + 1'b1;
				if (xfire0 >= a_hpos - 7 && xfire0 <= a_hpos + 15) begin
					if (yfire0 >= a_vpos - 7 && yfire0 <= a_vpos + 15) dead = 1;
				end else if (e_hpos >= a_hpos - 15 && e_hpos <= a_hpos + 15) begin
					if (e_vpos >= a_vpos - 15 && e_vpos <= a_vpos + 15) dead = 1;
				end else if (xfire1 >= a_hpos - 7 && xfire1 <= a_hpos + 15) begin
					if (yfire1 >= a_vpos - 7 && yfire1 <= a_vpos + 15) dead = 1;
				end else if (xfire0 >= e_hpos - 7 && xfire0 <= e_hpos + 15) begin
					if (yfire0 >= e_vpos - 7 && yfire0 <= e_vpos + 15) win = 1;
				end
				
				if(led == 8'h29) begin
					if (fire_counter == 0) begin
						xfire0 = a_hpos + 20;
						yfire0 = a_vpos;
						yfire0_d = random_counter;
						
						xfire1 = e_hpos - 20;
						yfire1 = e_vpos;
					end
					if (fire_counter <= 3) begin
						fire_counter = fire_counter + 1;
					end
				end
				
				if(xfire0 != 0 && yfire0 != 0) begin
					xfire0 = (xfire0_d == 0) ? xfire0 + 12 + level : xfire0 - 12 - level;
					yfire0 = (yfire0_d == 0) ? yfire0 + 12 + level : yfire0 - 12 - level;
					xfire1 = (xfire1_d == 0) ? xfire1 + 12 + level : xfire1 - 12 - level;
					yfire1 = (yfire1_d == 0) ? yfire1 + 12 + level : yfire1 - 12 - level;
					
					if(xfire0 <= 364) xfire0_d = 0;
					else if(xfire0 >= 563) xfire0_d = 1;
					if(yfire0 <= 221) yfire0_d = 0;
					else if(yfire0 >= 320) yfire0_d = 1;
					
					if(xfire1 <= 364) xfire1_d = 0;
					else if(xfire1 >= 563) xfire1_d = 1;
					if(yfire1 <= 221) yfire1_d = 0;
					else if(yfire1 >= 320) yfire1_d = 1;
				end 
			end
			random_counter = random_counter + 1;
	  end
	  
	  always@(posedge clk_0) begin
			if(rst) begin
				a_vpos <= 263;
				a_hpos <= 416;
			end else begin
				case({kup,kdown,kleft,kright})
				4'b1000: a_vpos <= a_vpos > 223 ? a_vpos - 3'd2 - level/2 : 221; // up
				4'b0100: a_vpos <= a_vpos < 318 ? a_vpos + 3'd2 + level/2 : 320; // down
				4'b0010: a_hpos <= a_hpos > 365 ? a_hpos - 3'd2 - level/2 : 364; // left
				4'b0001: a_hpos <= a_hpos < 546 ? a_hpos + 3'd2 + level/2 : 547; // right
				endcase
				ecount <= ecount + 1'b1;
			end
	  end
	  always@(posedge enemy_clk) begin
				if(rst) begin 
					h_enemy_dir = 0;
					v_enemy_dir = 0;
				end else begin
					e_hpos = h_enemy_dir == 0 ? e_hpos + 3'd4 + level : e_hpos - 3'd4 - level;
					e_vpos = v_enemy_dir == 0 ? e_vpos + 3'd3 + level : e_vpos - 3'd3 - level;
					h_enemy_dir = e_hpos <= 364 ? 0 : e_hpos >= 547 ? 1 : h_enemy_dir;
					v_enemy_dir = e_vpos <= 221 ? 0 : e_vpos >= 320 ? 1 : v_enemy_dir;
				end
	  end
	  
 endmodule    
