module DataHazard(clk,AluSrc,C,
					EX_MEM_RegWr,EX_MEM_Rd,
					ID_EX_Rs,ID_EX_Rt,
					MEM_WR_RegWr,MEM_WR_Rd,
					AluSrcA,AluSrcB);
input clk,AluSrc,C;
input EX_MEM_RegWr;
input [4:0]EX_MEM_Rd;

input [4:0]ID_EX_Rs;
input [4:0]ID_EX_Rt;

input MEM_WR_RegWr;
input [4:0]MEM_WR_Rd;


wire C1_A,C2_A,C1_B,C2_B;
assign C1_A=(EX_MEM_RegWr) && (EX_MEM_Rd!=0) && (EX_MEM_Rd==ID_EX_Rs);
assign C1_B=(EX_MEM_RegWr) && (EX_MEM_Rd!=0) && (EX_MEM_Rd==ID_EX_Rt);
assign C2_A=(MEM_WR_RegWr) && (MEM_WR_RegWr!=0) && (EX_MEM_Rd!=ID_EX_Rs) && (MEM_WR_Rd==ID_EX_Rs);
assign C2_B=(MEM_WR_RegWr) && (MEM_WR_RegWr!=0) && (EX_MEM_Rd!=ID_EX_Rt) && (MEM_WR_Rd==ID_EX_Rt);

output reg[1:0] AluSrcA;
output reg[1:0] AluSrcB;

always@(*)
begin
	if(C1_A==1 && C==0)
		AluSrcA=2'b01;
	if(C1_B==1 && C==0)
		AluSrcB=2'b01;
	if(C2_A==1)
		AluSrcA=2'b10;
	if(C2_B==1)
		AluSrcB=2'b10;
	if(C1_A!=1 && C2_A!=1)
		AluSrcA=2'b00;
	if(C1_B!=1 && C2_B!=1)
	begin
		if(AluSrc==0)
			AluSrcB=2'b00;
		else
			AluSrcB=2'b11;
	end
end
endmodule