`timescale 1ns / 1ps    
        
    module vga_controller(    
        input clk,   
		  input clk_1s,
        input rst,
        output reg [2:0] r,    
        output reg [2:0] g,    
        output reg [1:0] b,
		  input [7:0] led,
		  input win,
        output hs,    
        output vs,
		  output enemyCollide
        );    
        
//        parameter UP_BOUND = 31;    
//        parameter DOWN_BOUND = 510;    
//        parameter LEFT_BOUND = 144;    
//        parameter RIGHT_BOUND = 783; 
		  
		  //VGA wires, position registers
		  wire [2:0] red, green;
		  wire [1:0] blue;
		  reg [9:0] hcount, vcount; 
		  reg [9:0] a_hpos, a_vpos;
//		  e_hpos, e_vpos, e_hpos2, e_vpos2, e_hpos3, e_vpos3, e_hpos4, e_vpos4, e_hpos5, e_vpos5;
		  
		  reg [9:0] e_hpos = 368;
		  reg [9:0] e_vpos = 127; 

		//Ranger 2
		  reg [9:0] e_hpos2 = 672;
		  reg [9:0] e_vpos2 = 127;
		
		//Ranger 3
		  reg [9:0] e_hpos3 = 624;
		  reg [9:0] e_vpos3 = 329;
		
		//Ranger 4
		  reg [9:0] e_hpos4 = 256;
		  reg [9:0] e_vpos4 = 447;
		
		//Ranger 5
		  reg [9:0] e_hpos5 = 368;
		  reg [9:0] e_vpos5 = 383;
		  
		  wire pclk;
		  assign pclk = count[1];
		  wire [8:0] voffset, hoffset, e_voffset, e_hoffset;
        
		  assign vs = (vcount < 2) ? 1'b0 : 1'b1;
		  
		  reg [1:0] step = 0;		  
        reg [1:0] count;		  
        
		  wire clk_0;
		  
		  //Sprite Select Wires and Memory Modules
		  wire display_ash, display_enemy, display_enemy2, display_enemy3, display_enemy4, display_enemy5;
		  wire [7:0] AshData, EnemyData, EnemyData2, EnemyData3, EnemyData4, EnemyData5;
		  reg [15:0] ranger_count = 0;
		  reg [3:0] rangering = 0;
		  
		  Ash ash(
			  .clka(pclk), // input clka
			  .addra((((vcount - a_vpos) % 16 + voffset) * 48 + (hcount - a_hpos + hoffset)) * 1), // input [31 : 0] addra
			  .douta(AshData) // output [31 : 0] AshData
			);

		  Enemy rocket(
			  .clka(pclk), // input clka
			  .addra((((vcount - e_vpos) % 16 + e_voffset) * 48 + (hcount - e_hpos + e_hoffset)) * 1), // input [31 : 0] addra
			  .douta(EnemyData) // output [31 : 0] AshData
			);
			
			Enemy rocket2(
			  .clka(pclk), // input clka
			  .addra((((vcount - e_vpos2) % 16 + e_voffset) * 48 + (hcount - e_hpos2 + e_hoffset)) * 1), // input [31 : 0] addra
			  .douta(EnemyData2) // output [31 : 0] AshData
			);
			
			Enemy rocket3(
			  .clka(pclk), // input clka
			  .addra((((vcount - e_vpos3) % 16 + e_voffset) * 48 + (hcount - e_hpos3 + e_hoffset)) * 1), // input [31 : 0] addra
			  .douta(EnemyData3) // output [31 : 0] AshData
			);
			
			Enemy rocket4(
			  .clka(pclk), // input clka
			  .addra((((vcount - e_vpos4) % 16 + e_voffset) * 48 + (hcount - e_hpos4 + e_hoffset)) * 1), // input [31 : 0] addra
			  .douta(EnemyData4) // output [31 : 0] AshData
			);
			
			Enemy rocket5(
			  .clka(pclk), // input clka
			  .addra((((vcount - e_vpos5) % 16 + e_voffset) * 48 + (hcount - e_hpos5 + e_hoffset)) * 1), // input [31 : 0] addra
			  .douta(EnemyData5) // output [31 : 0] AshData
			);
					
		  
		  
		  wire kleft, kright, kup, kdown;
		  wire [2:0] CON;
		  assign kleft = led == 8'h6b ? 1'b1 : 1'b0;
		  assign kright = led == 8'h74 ? 1'b1 : 1'b0;
		  assign kup = led == 8'h75 ? 1'b1 : 1'b0;
		  assign kdown = led == 8'h72 ? 1'b1 : 1'b0;
		  
		  //Player and enemy position
		  wire [19:0] position, e_position, e_position2, e_position3, e_position4, e_position5;
		  assign e_position = {e_hpos, e_vpos};
		  assign e_position2 = {e_hpos2, e_vpos2};
		  assign e_position3 = {e_hpos3, e_vpos3};
		  assign e_position4 = {e_hpos4, e_vpos4};
		  assign e_position5 = {e_hpos5, e_vpos5};
		  //Sprite Display Control
		  assign display_ash = (hcount - a_hpos <= 16 && hcount - a_hpos > 0 && vcount - a_vpos >= 0 && vcount - a_vpos < 16);
		  assign display_enemy = (hcount - e_hpos <= 16 && hcount - e_hpos > 0 && vcount - e_vpos >= 0 && vcount - e_vpos < 16);
		  assign display_enemy2 = (hcount - e_hpos2 <= 16 && hcount - e_hpos2 > 0 && vcount - e_vpos2 >= 0 && vcount - e_vpos2 < 16);
		  assign display_enemy3 = (hcount - e_hpos3 <= 16 && hcount - e_hpos3 > 0 && vcount - e_vpos3 >= 0 && vcount - e_vpos3 < 16);
		  assign display_enemy4 = (hcount - e_hpos4 <= 16 && hcount - e_hpos4 > 0 && vcount - e_vpos4 >= 0 && vcount - e_vpos4 < 16);
		  assign display_enemy5 = (hcount - e_hpos5 <= 16 && hcount - e_hpos5 > 0 && vcount - e_vpos5 >= 0 && vcount - e_vpos5 < 16);
		      
		  //Clock Dividers
		  
		  clk_250ms							clk2(clk,clk_0);
		  
		  
		  //Collision Detection
		  /*
			Collision Matrix but Easier to See:
			20 x 15, multiply by 32 to fill screen
			
			10111111111111111111
			10000000000010000001
			11111111111010101101
			10000010001010100101
			10101011101010100101
			10101000001010100101
			10101111111010110101
			10100000100010000101
			10111110101010100101
			10100000101000100101
			10101111101011110101
			10100010001010000101
			10111011111110101101
			10001000000000100001
			11111111111111111101
		  */

		  wire [19:0] newPosition;
		  //wire enemyCollide;
		
		  //Move Player Module
		  Move_Module m0(e_position, e_position2, e_position3, e_position4, e_position5, clk_0, {kup,kdown,kleft,kright}, win, enemyCollide, CON, newPosition);
		  
		  
		   //Update Player and Enemy Position
		  always@(posedge clk) begin
				{a_hpos, a_vpos} <= newPosition;
				
				{e_hpos, e_vpos} <= CON == 1 ? 20'b0 : {e_hpos, e_vpos};
				{e_hpos2, e_vpos2} <= CON == 2 ? 20'b0 : {e_hpos2, e_vpos2};
				{e_hpos3, e_vpos3} <= CON == 3 ? 20'b0 : {e_hpos3, e_vpos3};
				{e_hpos4, e_vpos4} <= CON == 4 ? 20'b0 : {e_hpos4, e_vpos4};
				{e_hpos5, e_vpos5} <= CON == 5 ? 20'b0 : {e_hpos5, e_vpos5};
		  end
		  
		  //Display Select
		  Background Dis(pclk, clk_1s, hcount, vcount, {red,green,blue});
		  Sprite_Sel SEL0(pclk, {kup, kdown, kleft, kright}, step, hoffset, voffset);
		  Sprite_Sel SEL1(pclk, rangering, step, e_hoffset, e_voffset);
		  
		  //Reset
		  always @ (posedge clk)    
        begin    
            if (rst)     
                count <= 1'b0;    
            else    
                count <= count + 1'b1;    
        end    
		   
		  //Horizontal VGA
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
		  
        //Vertical VGA
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
		  
		  
		  //VGA Color Select
        always @ (posedge pclk)    
        begin
				
				//If we want to display Ash
				if(display_ash) begin
					if(AshData == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= AshData[7:5];
						g <= AshData[4:2];
						b <= AshData[1:0];
					end
				end
				//If we want to display the enemy
				else if(display_enemy) begin
					if(EnemyData == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= EnemyData[7:5];
						g <= EnemyData[4:2];
						b <= EnemyData[1:0];
					end
				end
				
				//enemy 2 display
				else if(display_enemy2) begin
					if(EnemyData2 == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= EnemyData2[7:5];
						g <= EnemyData2[4:2];
						b <= EnemyData2[1:0];
					end
				end
				
				//enemy 3 display
				else if(display_enemy3) begin
					if(EnemyData3 == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= EnemyData3[7:5];
						g <= EnemyData3[4:2];
						b <= EnemyData3[1:0];
					end
				end
				
				//enemy 4 display
				else if(display_enemy4) begin
					if(EnemyData4 == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= EnemyData4[7:5];
						g <= EnemyData4[4:2];
						b <= EnemyData4[1:0];
					end
				end
				
				//enemy 5 display
				else if(display_enemy5) begin
					if(EnemyData5 == 8'b11111111) begin
						r <= red;
						g <= green;
						b <= blue;
					end
					
					else begin
						r <= EnemyData5[7:5];
						g <= EnemyData5[4:2];
						b <= EnemyData5[1:0];
					end
				end
				
				else begin
					r <= red;
					g <= green;
					b <= blue;
				end
				
		  end
		  
		  //Increase Steps
		  always@(posedge clk_1s) begin
				step = step + 1'b1;
		  end
    endmodule    