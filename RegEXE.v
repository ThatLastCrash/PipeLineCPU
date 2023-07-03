module RegEXE(clk,run,
			EXE_RegWr,EXE_Rw,EXE_Result,EXE_MemWr,EXE_busB,EXE_MemtoReg,EXE_Rd,
			MEM_RegWr,MEM_Rw,MEM_Result,MEM_MemWr,MEM_busB,MEM_MemtoReg,MEM_Rd);
input clk,run;
input EXE_RegWr,EXE_MemWr,EXE_MemtoReg;
input [4:0]EXE_Rw;
input [31:0]EXE_Result;
input [31:0]EXE_busB;
input [4:0]EXE_Rd;

output reg MEM_RegWr,MEM_MemWr,MEM_MemtoReg;
output reg[4:0]MEM_Rw;
output reg[31:0]MEM_Result;
output reg[31:0]MEM_busB;
output reg[4:0]MEM_Rd;

always@(negedge clk)
begin
	MEM_Rw=EXE_Rw;
	MEM_RegWr=EXE_RegWr;
	MEM_MemWr=EXE_MemWr;
	MEM_MemtoReg=EXE_MemtoReg;
	MEM_Result=EXE_Result;
	MEM_busB=EXE_busB;
	MEM_Rd=EXE_Rd;
end
endmodule