module mux2to1_MEM(clk,busB,immOut,AluSrc,busOut);
input clk;
input [31:0] busB;
input [31:0] immOut;
input AluSrc;
output reg [31:0] busOut;

//assign busOut=AluSrc?immOut:busB;
always@(posedge clk)
begin
	busOut=AluSrc?immOut:busB;
end
endmodule