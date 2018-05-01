 module dff_async_reset (
 input data  , // Data Input
 input clk    , // Clock Input
 input reset , // Reset input 
 output reg q ,        // Q output
 output reg qnot
 );

 
 //-------------Code Starts Here---------
 always @ ( posedge clk or posedge reset)
 if (reset) begin
   q <= 1'b0;
 end  else begin
   q <= data;
   qnot <= ~data;
 end
 
 endmodule //End Of Module dff_async_reset