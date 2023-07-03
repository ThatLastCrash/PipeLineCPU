module RegMEM(clk,run,
			MEM_RegWr,MEM_Rw,MEM_busW,
			Wr_RegWr,Wr_Rw,Wr_busW);
input clk,run;
input MEM_RegWr;
input [4:0]MEM_Rw;
input [31:0]MEM_busW;

output reg Wr_RegWr;
output reg[4:0]Wr_Rw;
output reg[31:0]Wr_busW;

always@(negedge clk)
begin
	Wr_RegWr=MEM_RegWr;
	Wr_Rw=MEM_Rw;
	Wr_busW=MEM_busW;
end
endmodule