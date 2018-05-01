module Keyboard_PS2
(
input					clk_in,				
input					rst_n_in,			
input					key_clk,			
input					key_data,				
output	[7:0]		ascii,
output key_break		
);
 

reg		key_clk_r0 = 1'b1,key_clk_r1 = 1'b1; 
reg		key_data_r0 = 1'b1,key_data_r1 = 1'b1;
reg		[7:0]	key_ascii;
reg 		key_state;
assign ascii = key_state == 1 ? key_ascii : 8'hf0;
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		key_clk_r0 <= 1'b1;
		key_clk_r1 <= 1'b1;
		key_data_r0 <= 1'b1;
		key_data_r1 <= 1'b1;
	end else begin
		key_clk_r0 <= key_clk;
		key_clk_r1 <= key_clk_r0;
		key_data_r0 <= key_data;
		key_data_r1 <= key_data_r0;
	end
end
 

wire	key_clk_neg = key_clk_r1 & (~key_clk_r0); 
 
reg				[3:0]	cnt; 
reg				[7:0]	temp_data;

always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		cnt <= 4'd0;
		temp_data <= 8'd0;
	end else if(key_clk_neg) begin 
		if(cnt >= 4'd10) cnt <= 4'd0;
		else cnt <= cnt + 1'b1;
		case (cnt)
			4'd0: ;	
			4'd1: temp_data[0] <= key_data_r1;  
			4'd2: temp_data[1] <= key_data_r1;  
			4'd3: temp_data[2] <= key_data_r1;  
			4'd4: temp_data[3] <= key_data_r1;  
			4'd5: temp_data[4] <= key_data_r1;  
			4'd6: temp_data[5] <= key_data_r1;  
			4'd7: temp_data[6] <= key_data_r1;  
			4'd8: temp_data[7] <= key_data_r1;  
			4'd9: ;	
			4'd10:;	
			default: ;
		endcase
	end
end
 
reg				key_break = 1'b0;   
reg				[7:0]	key_byte = 1'b0;

always @ (posedge clk_in or negedge rst_n_in) begin 
	if(!rst_n_in) begin
		key_break <= 1'b0;
		key_state <= 1'b0;
		key_byte <= 1'b0;
	end else if(cnt==4'd10 && key_clk_neg) begin 
		if(temp_data == 8'hf0) key_break <= 1'b1;	
		else if(!key_break) begin 
			key_state <= 1'b1;
			key_byte <= temp_data; 
		end else begin	
			key_state <= 1'b0;
			key_break <= 1'b0;
		end
	end
end
 

always @ (key_byte) begin
	case (key_byte)    //translate key_byte to key_ascii
		8'h15: key_ascii = "Q";//8'h51;   //Q
		8'h1d: key_ascii = "W";//8'h57;   //W
		8'h24: key_ascii = "E";//8'h45;   //E
		8'h2d: key_ascii = "R";//8'h52;   //R
		8'h2c: key_ascii = "T";//8'h54;   //T
		8'h35: key_ascii = "Y";//8'h59;   //Y
		8'h3c: key_ascii = "U";//8'h55;   //U
		8'h43: key_ascii = "I";//8'h49;   //I
		8'h44: key_ascii = "O";//8'h4f;   //O
		8'h4d: key_ascii = "P";//8'h50;   //P
		8'h1c: key_ascii = "A";//8'h41;   //A
		8'h1b: key_ascii = "S";//8'h53;   //S
		8'h23: key_ascii = "D";//8'h44;   //D
		8'h2b: key_ascii = "F";//8'h46;   //F
		8'h34: key_ascii = "G";//8'h47;   //G
		8'h33: key_ascii = "H";//8'h48;   //H
		8'h3b: key_ascii = "J";//8'h4a;   //J
		8'h42: key_ascii = "K";//8'h4b;   //K
		8'h4b: key_ascii = "L";//8'h4c;   //L
		8'h1a: key_ascii = "Z";//8'h5a;   //Z
		8'h22: key_ascii = "X";//8'h58;   //X
		8'h21: key_ascii = "C";//8'h43;   //C
		8'h2a: key_ascii = "V";//8'h56;   //V
		8'h32: key_ascii = "B";//8'h42;   //B
		8'h31: key_ascii = "N";//8'h4e;   //N
		8'h3a: key_ascii = "M";//8'h4d;   //M
		default: key_ascii = key_byte;
	endcase
end
 
endmodule