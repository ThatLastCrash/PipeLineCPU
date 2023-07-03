module Controller(clk,run,ID_pc,ID_instru,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_RegDst,Rs,Rt,Rd,
			ID_addr_change,op,func);
input [29:0]ID_pc;
input [31:0]ID_instru;
output [15:0]ID_imm16;
output [2:0]ID_AluCtr;
output ID_AluSrc;
output ID_ExtOP;
output ID_MemWr;
output ID_MemtoReg;
output ID_RegWr;
output ID_RegDst;
output [4:0]Rs;
output [4:0]Rt;
output [4:0]Rd;

output [5:0]op;
output [5:0]func;

assign op=ID_instru[31:26];
assign Rs=ID_instru[25:21];
assign Rt=ID_instru[20:16];
assign Rd=ID_instru[15:11];
assign func=ID_instru[5:0];
assign ID_imm16=ID_instru[15:0];

assign ID_Branch=(!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]);
assign ID_Jump=(!op[5]&!op[4]&!op[3]&!op[2]&op[1]&!op[0]);
assign ID_RegDst=(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
assign ID_AluSrc=(!ID_RegDst)&(!(!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]));
assign ID_MemtoReg=(op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
assign ID_MemWr=(op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0]);
assign ID_ExtOP=!(!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0]);

assign ID_RegWr=(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])
			+(!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0])
			+(!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])
			+(op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
/*
assign ALUop[2]=!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0];
assign ALUop[1]=!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0];
assign ALUop[0]=!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0];
*/
assign ID_AluCtr[2]=ID_RegDst?(!func[2]&func[1]):(!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]);
assign ID_AluCtr[1]=ID_RegDst?(func[3]&!func[2]&func[1]):(!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0]);
assign ID_AluCtr[0]=ID_RegDst?((!func[3]&!func[2]&!func[1]&!func[0])+(!func[2]&func[1]&!func[0])):(!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);

//jump or beq
input clk,run;
output [31:0]ID_addr_change;

wire branch_zero;
wire zero;

wire [29:0]temp1;
wire [29:0]temp2;

wire [29:0]temp3;
wire [31:0]temp4;

wire [29:0]M2;
assign temp1=ID_pc;
assign temp2=ID_instru[15:0];
assign	zero=(Rs==Rt)?1:0;
assign	branch_zero = ID_Branch & zero;
assign	temp3 =ID_pc + 1 + (branch_zero ? ID_instru[15:0] : 0);
assign	temp4 ={(ID_Jump?M2:temp3),2'b00};
assign	ID_addr_change=(branch_zero==1 || ID_Jump==1)?temp4:32'b0;
/*
//上升沿检测是否要转移或跳转，可以在ID结束时直接改变下一条指令地址
always@(posedge clk)
begin 
	//pc=temp4[31:2];
	zero=(Rs==Rt)?1:0;
	branch_zero = ID_Branch & zero;
	temp3 =ID_pc + (branch_zero ? ID_instru[15:0] : 0);
	temp4 ={(ID_Jump?M2:temp3),2'b00};
	//beq或jump，若啥也不干则是32'b0
	ID_addr_change=(branch_zero==1 || ID_Jump==1)?temp4:32'b0;
end*/
//mux2to1 mux1(clk,temp1,temp2,branch_zero,temp3); // branch  跳转地址
//assign temp3 = temp1 + 1 + (branch_zero ? temp2 : 0);

assign M2={ID_pc[29:26],ID_instru[25:0]};          // jump    跳转地址

endmodule