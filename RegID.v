module RegID(clk,run,ID_addr_change,
			ID_MemWr,ID_MemtoReg,ID_RegWr,ID_Rw,ID_busA,ID_busB,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_Rs,ID_Rt,ID_Rd,ID_op,
			EXE_MemWr,EXE_MemtoReg,EXE_RegWr,EXE_Rw,EXE_busA,EXE_busB,EXE_imm16,EXE_ExtOP,EXE_AluSrc,EXE_AluCtr,EXE_Rs,EXE_Rt,EXE_Rd,EXE_MemRead);
input clk,run;
input [31:0]ID_addr_change;
input ID_MemWr,ID_MemtoReg,ID_RegWr,ID_ExtOP,ID_AluSrc;
input [4:0]ID_Rw;
input [31:0]ID_busA;
input [31:0]ID_busB;
input [15:0]ID_imm16;
input [2:0]ID_AluCtr;
input [4:0]ID_Rs;
input [4:0]ID_Rt;
input [4:0]ID_Rd;
input [5:0]ID_op;

output reg EXE_MemWr,EXE_MemtoReg,EXE_RegWr,EXE_ExtOP,EXE_AluSrc;
output reg [4:0]EXE_Rw;
output reg [31:0]EXE_busA;
output reg [15:0]EXE_busB;
output reg [15:0]EXE_imm16;
output reg [2:0]EXE_AluCtr;
output reg[4:0]EXE_Rs;
output reg[4:0]EXE_Rt;
output reg[4:0]EXE_Rd;
output reg EXE_MemRead;
always@(negedge clk)
begin
if(run==0 && ID_addr_change==32'b0)
	begin
		EXE_MemWr=ID_MemWr;
		EXE_MemtoReg=ID_MemtoReg;
		EXE_RegWr=ID_RegWr;
		EXE_ExtOP=ID_ExtOP;
		EXE_AluSrc=ID_AluSrc;
		EXE_Rw=ID_Rw;
		EXE_busA=ID_busA;
		EXE_busB=ID_busB;
		EXE_imm16=ID_imm16;
		EXE_AluCtr=ID_AluCtr;
		
		EXE_Rs=ID_Rs;
		EXE_Rt=ID_Rt;
		EXE_Rd=ID_Rd;
		
		//上一条指令是load
		if(ID_op==6'b100011)
			EXE_MemRead=1;
		else
			EXE_MemRead=0;
	end
else
	begin
		EXE_MemWr=0;
		EXE_MemtoReg=0;
		EXE_RegWr=0;
		EXE_ExtOP=0;
		EXE_AluSrc=0;
		EXE_Rw=0;
		EXE_busA=0;
		EXE_busB=0;
		EXE_imm16=0;
		EXE_AluCtr=0;
		
		EXE_Rs=0;
		EXE_Rt=0;
		EXE_Rd=0;
		EXE_MemRead=0;
	end
end
endmodule