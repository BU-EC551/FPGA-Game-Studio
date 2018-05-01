  
`timescale 1ns / 1ps    
        
 module battle_screen(    
	  input clk,    
	  input rst,
	  input [15:0] HP,
	  output reg [2:0] r,    
	  output reg [2:0] g,    
	  output reg [1:0] b,    
	  output hs,    
	  output vs    
	  );    
	  
//	  parameter UP_BOUND = 31;    
//	  parameter DOWN_BOUND = 510;    
//	  parameter LEFT_BOUND = 144;    
//	  parameter RIGHT_BOUND = 783;    

	  wire pclk; 
	  wire [7:0] grass, douta, wpdouta, bpdouta, AshData, EnemyData, PHP, EHP;	  
	  reg [1:0] count;		  
	  reg [9:0] hcount, vcount;    
	  reg [9:0] hp_xpos = 200;
	  reg [9:0] hp_ypos = 51;
	  
	  reg [9:0] pp_xpos = 600;
	  reg [9:0] pp_ypos = 51;
	  
	  reg [9:0] bp_xpos = 680;
	  reg [9:0] bp_ypos = 51;
	  
	  reg [9:0] a_vpos = 263;
	  reg [9:0] a_hpos = 416;
	  
	  reg [9:0] e_vpos = 263;
	  reg [9:0] e_hpos = 512;
	  
	  assign pclk = count[1];    
	  assign PHP = HP[15:8];
	  assign EHP = HP[7:0];
	  
	  Grass grass0 (
		  .clka(pclk), // input clka
		  .addra((vcount%8) * 8 + hcount%8), // input [5 : 0] addra
		  .douta(grass) // output [7 : 0] douta
		);
		WeaponAndHeart wp0 (
		  .clka(pclk), // input clka
		  .addra(((vcount - pp_ypos)%32) * 32 + (16 + hcount - pp_xpos)%32), // input [10 : 0] addra
		  .douta(wpdouta) // output [7 : 0] douta
		);
		
		WeaponAndHeart wp1 (
		  .clka(pclk), // input clka
		  .addra(((vcount - bp_ypos)%32) * 32 + (16 + hcount - bp_xpos)%32), // input [10 : 0] addra
		  .douta(bpdouta) // output [7 : 0] douta
		);
		
		WeaponAndHeart hp (
		  .clka(pclk), // input clka
		  .addra(((vcount - hp_ypos)%32) * 32 + (hcount - hp_xpos)%32), // input [9 : 0] addra
		  .douta(douta) // output [7 : 0] douta
		);
		Ash ash0(
			  .clka(pclk), // input clka
			  .addra(((vcount - a_vpos) % 16 + 48) * 48 + (hcount - a_hpos)), // input [31 : 0] addra
			  .douta(AshData) // output [31 : 0] AshData
			);

	   Enemy rocket0(
			  .clka(pclk), // input clka
			  .addra(((vcount - e_vpos) % 16 + 32) * 48 + (hcount - e_hpos)), // input [31 : 0] addra
			  .douta(EnemyData) // output [31 : 0] AshData
			);
	  reg [7:0] test = 56;
	  reg [7:0] test1 = 72;
	  reg [7:0] test2 = 17;
	  reg [7:0] test3 = 08;
	  reg [7:0] test4 = 29;
	  reg [7:0] test5 = 34;
	  
	  wire [8:0] Deci, Deci1, Deci2, Deci3, Deci4, Deci5;
	  wire [7:0] v_offset0, v_offset1;
	  wire [3:0] h_offset0, h_offset1, h_offset2, h_offset3, h_offset4, h_offset5, h_offset6; 
	  wire [0:7] Num0, Num1, Num2, Num3, Num4, Num5, Num6, Num7, Num8, Num9, Num10, Num11, Num12, Num13;
	  
	  assign v_offset0 = (vcount - 51) % 16;
	  assign v_offset1 = (vcount - 67) % 16;
	  
	  assign h_offset0 = (hcount - 216) % 8;
	  assign h_offset1 = (hcount - 224) % 8;
	  assign h_offset2 = (hcount - 232) % 8;
	  
	  assign h_offset3 = (hcount - 616) % 8;
	  assign h_offset4 = (hcount - 624) % 8;
	  
	  assign h_offset5 = (hcount - 696) % 8;
	  assign h_offset6 = (hcount - 712) % 8;
	  
	  
	  
	  //Player Hp
	  BtoD btd0(test, Deci);
	  font_rom f0((8'h30 + Deci[8])*16 + v_offset0, Num0);
	  font_rom f1((8'h30 + Deci[7:4])*16 + v_offset0, Num1);
	  font_rom f2((8'h30 + Deci[3:0])*16 + v_offset0, Num2);
	  //Enemy Hp
	  BtoD btd1(test1, Deci1);
	  font_rom f3((8'h30 + Deci1[8])*16 + v_offset1, Num3);
	  font_rom f4((8'h30 + Deci1[7:4])*16 + v_offset1, Num4);
	  font_rom f5((8'h30 + Deci1[3:0])*16 + v_offset1, Num5);
	  
	  //Player PP
	  BtoD btd2(test2, Deci2);
	  BtoD btd3(test3, Deci3);
	  font_rom f6((8'h30 + Deci2[7:4])*16 + v_offset0, Num6);
	  font_rom f7((8'h30 + Deci2[3:0])*16 + v_offset0, Num7);
	  font_rom f8((8'h30 + Deci3[7:4])*16 + v_offset1, Num8);
	  font_rom f9((8'h30 + Deci3[3:0])*16 + v_offset1, Num9);
	  
	  //Enemy PP
	  BtoD btd4(test4, Deci4);
	  BtoD btd5(test5, Deci5);
	  font_rom f10((8'h30 + Deci4[7:4])*16 + v_offset0, Num10);
	  font_rom f11((8'h30 + Deci4[3:0])*16 + v_offset0, Num11);
	  font_rom f12((8'h30 + Deci5[7:4])*16 + v_offset1, Num12);
	  font_rom f13((8'h30 + Deci5[3:0])*16 + v_offset1, Num13);
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
						if (vcount>=hp_ypos && vcount<=hp_ypos+31    
							&& hcount>hp_xpos && hcount<=hp_xpos+16) begin 
							  r <= douta != 8'hff ? douta[7:5] : grass[7:5];    
							  g <= douta != 8'hff ? douta[4:2] : grass[4:2];    
							  b <= douta != 8'hff ? douta[1:0] : grass[1:0];
						end else if (vcount>=pp_ypos && vcount<=pp_ypos+31   
							&& hcount>=pp_xpos && hcount<=pp_xpos+16) begin 
							  r <= wpdouta != 8'hff ? wpdouta[7:5] : grass[7:5];    
							  g <= wpdouta != 8'hff ? wpdouta[4:2] : grass[4:2];    
							  b <= wpdouta != 8'hff ? wpdouta[1:0] : grass[1:0];
						end else if (vcount>=bp_ypos && vcount<=bp_ypos+31    
							&& hcount>=bp_xpos && hcount<=bp_xpos+16) begin 
							  r <= bpdouta != 8'hff ? bpdouta[7:5] : grass[7:5];    
							  g <= bpdouta != 8'hff ? bpdouta[4:2] : grass[4:2];    
							  b <= bpdouta != 8'hff ? bpdouta[1:0] : grass[1:0];
						end else if (vcount>=a_vpos && vcount<=a_vpos+15    
							&& hcount>=a_hpos && hcount<=a_hpos+15) begin 
							  r <= AshData != 8'hff ? AshData[7:5] : grass[7:5];    
							  g <= AshData != 8'hff ? AshData[4:2] : grass[4:2];    
							  b <= AshData != 8'hff ? AshData[1:0] : grass[1:0];
						end else if (vcount>=e_vpos && vcount<=e_vpos+15    
							&& hcount>=e_hpos && hcount<=e_hpos+15) begin 
							  r <= EnemyData != 8'hff ? EnemyData[7:5] : grass[7:5];    
							  g <= EnemyData != 8'hff ? EnemyData[4:2] : grass[4:2];    
							  b <= EnemyData != 8'hff ? EnemyData[1:0] : grass[1:0];
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=216 && hcount<=223) begin
								if (Num0[h_offset0]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=224 && hcount<=231) begin
								if (Num1[h_offset1]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=232 && hcount<=239) begin
								if (Num2[h_offset2]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=216 && hcount<=223) begin
								if (Num3[h_offset0]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82     
							&& hcount>=224 && hcount<=231) begin
								if (Num4[h_offset1]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=232 && hcount<=239) begin
								if (Num5[h_offset2]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=616 && hcount<=623) begin
								if (Num6[h_offset3]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=624 && hcount<=631) begin
								if (Num7[h_offset4]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=616 && hcount<=623) begin
								if (Num8[h_offset3]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=624 && hcount<=631) begin
								if (Num9[h_offset4]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=696 && hcount<=703) begin
								if (Num10[h_offset5]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=51 && vcount<=66    
							&& hcount>=704 && hcount<=711) begin
								if (Num11[h_offset6]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=696 && hcount<=703) begin
								if (Num12[h_offset5]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
								end 
							   else begin
								  r <= grass[7:5];    
								  g <= grass[4:2];    
								  b <= grass[1:0];
							  end
						end else if (vcount>=67 && vcount<=82    
							&& hcount>=704 && hcount<=711) begin
								if (Num13[h_offset6]) begin
										  r <= 3'b111;    
										  g <= 3'b000;    
										  b <= 2'b00;
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
