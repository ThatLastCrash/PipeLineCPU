module PipeLineCPU(clk,run,
		IF_pc,
		IF_instru,           // PCֵ��ȡ��ָ��
		IF_addr_mem,
		
		/*
		IF_RegWr,			//�Ĵ���дʹ��
		IF_Branch,IF_Jump,	//��ת��־
		IF_ExtOP,		//��������չ�з��Ż����޷���
		IF_AluSrc,		//alu����Դѡ���־
		IF_MemWr,		//�洢��дʹ��
		IF_MemtoReg,	//���ս��ѡ���־��1�Ǵ洢����0��alu������
		IF_RegDst,		//Ŀ�ļĴ���ѡ��
		IF_AluCtr,  		 // ALU���������źţ�1����������0��busB
		*/
		ID_op,ID_func,
		//ID_addr_change,
		//ID_pc,
		ID_instru,
		ID_Rw,					
		ID_Rs,ID_Rt,ID_Rd,
		ID_busA,ID_busB,
		ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_RegDst,
		ID_imm16,
		
		EXE_busOutA,
		EXE_busOutB,   		 //busB ѡ������Դ������
		EXE_Result,    		 //ALU�Ľ��
		//EXE_immOut,
		EXE_MemWr,
		EXE_MemtoReg,
		EXE_RegWr,
		EXE_Overflow,
		EXE_busA,
		EXE_busB,
		EXE_Rw,
		EXE_Rs,EXE_Rt,EXE_Rd,
		//EXE_imm16,
		EXE_ExtOP,
		EXE_AluSrc,
		EXE_AluCtr,
		
		MEM_busW,			//�Ĵ���
		MEM_DataOut,		 // �洢����������ֵ
		MEM_MemtoReg,
		MEM_RegWr,
		MEM_Rw,
		MEM_Result,
		MEM_MemWr,
		//MEM_busB,
		MEM_Rd,
		
		Wr_RegWr,
		Wr_Rw,
		Wr_busW,
		
		AluSrcA,AluSrcB,
		C,EXE_MemRead,
		Zero            // 0�ź�alu��ZF
		//imm16			//������ 
		//wrre    
		);
input clk,run;
//input RegWr,Branch,Jump,ExtOP,AluSrc,MemWr,MemtoReg,RegDst;
//input [2:0]AluCtr;
//input [15:0]imm16;
output [29:0]IF_pc;
output [31:0]IF_instru;
//output wire IF_RegWr,IF_Branch,IF_Jump,IF_ExtOP,IF_AluSrc,IF_MemWr,IF_MemtoReg,IF_RegDst;
//output wire [2:0]IF_AluCtr;
output wire [31:0]IF_addr_mem;

output wire [5:0]ID_op;
output wire [5:0]ID_func;
 wire [31:0]ID_addr_change;
wire [29:0]ID_pc;
output [31:0]ID_instru;
output wire [15:0]ID_imm16;
output wire [2:0]ID_AluCtr;
output wire ID_ExtOP,ID_AluSrc,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_RegDst;
output [4:0]ID_Rw;
output [4:0]ID_Rs;
output [4:0]ID_Rt;
output [4:0]ID_Rd;
output reg[31:0]ID_busA;
output reg[31:0]ID_busB;

wire [31:0]EXE_immOut;
output wire EXE_MemWr,EXE_MemtoReg,EXE_RegWr;
output [31:0]EXE_busOutA;
output [31:0]EXE_busOutB;
output [31:0]EXE_Result;
output EXE_Overflow;
output [31:0]EXE_busA;
output [31:0]EXE_busB;
output [4:0]EXE_Rw;
output [4:0]EXE_Rs;
output [4:0]EXE_Rt;
output [4:0]EXE_Rd;
wire 	[15:0]EXE_imm16;
output	EXE_ExtOP;
output	EXE_AluSrc;
output	[2:0]EXE_AluCtr;

output [31:0] MEM_busW;
output [31:0]MEM_DataOut;
output MEM_MemtoReg,MEM_RegWr,MEM_MemWr;
output [4:0]MEM_Rw;
output	[31:0]MEM_Result;
wire	[31:0]MEM_busB;
output [4:0]MEM_Rd;

output	Wr_RegWr;
output	[4:0]Wr_Rw;
output	[31:0]Wr_busW;

output	[1:0]AluSrcA;
output	[1:0]AluSrcB;
output C,EXE_MemRead;
output Zero;
//IF
//ȡָ��,��instru��,pc+4��IF_pc��
Instruction ins(clk,C,IF_instru,IF_pc,IF_addr_mem,ID_addr_change);      
//�½��ش������ݺ��ź�
RegIF regif(clk,C,
			IF_instru,IF_pc,ID_instru,ID_pc);


//ID
//ȡ�����룬���ɿ����ź�
Controller con(clk,run,ID_pc,ID_instru,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_RegDst,ID_Rs,ID_Rt,ID_Rd,
	ID_addr_change,ID_op,ID_func);
// ȷ��Ŀ�ļĴ���RW
mux2to1_regdst mux1(ID_Rt,ID_Rd,ID_RegDst,ID_Rw);


//��ʼ���Ĵ���
reg [32:1]REG_Files[0:32-1];
integer i;

initial
	for(i=0;i<32;i=i+1) REG_Files[i]<=i;

//�����ض����½���д
always@(posedge clk)
begin
	ID_busA=REG_Files[ID_Rs];
	ID_busB=REG_Files[ID_Rt];
end


//�õ�busA,busB,�����ض����ݺͼ���
//RegFile rreg(clk,ID_RegWr,ID_Rw,ID_Rs,ID_Rt,ID_busA,ID_busB);	


//loaduseð��
LoadUse loaduse(clk,C,EXE_MemRead,EXE_Rt,ID_Rs,ID_Rt);
//�½��ش������ݺ��ź�
RegID regid(clk,C,ID_addr_change,
			ID_MemWr,ID_MemtoReg,ID_RegWr,ID_Rw,ID_busA,ID_busB,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_Rs,ID_Rt,ID_Rd,ID_op,
			EXE_MemWr,EXE_MemtoReg,EXE_RegWr,EXE_Rw,EXE_busA,EXE_busB,EXE_imm16,EXE_ExtOP,EXE_AluSrc,EXE_AluCtr,EXE_Rs,EXE_Rt,EXE_Rd,EXE_MemRead);


//EXE
signZeroExtend sz(EXE_imm16,EXE_ExtOP,EXE_immOut);  	       // 0,1��չ

//����ð�գ��ж��Ƿ���ð�գ�����A��B�����ݸ���
DataHazard dataHazard(clk,EXE_AluSrc,C,
						MEM_RegWr,MEM_Rw,
						EXE_Rs,EXE_Rt,
						Wr_RegWr,Wr_Rw,
						AluSrcA,AluSrcB);

//A����ѡһ��B����ѡһ
mux4to1 m4to1_A(EXE_AluSrc,AluSrcA,EXE_busA,MEM_Result,Wr_busW,EXE_busA,EXE_busOutA);
//mux2to1 mux2(EXE_busB,EXE_immOut,EXE_AluSrc,EXE_busOutB);                     //busB ѡ������Դ������������alu
mux4to1 m4to1_B(EXE_AluSrc,AluSrcB,EXE_busB,MEM_Result,Wr_busW,EXE_immOut,EXE_busOutB);


//alu����ó������result��
//EXE_busOut��ALU��B��
//�����ض����ݺͼ���
ALU alu(clk,EXE_busOutA,EXE_busOutB,EXE_AluCtr,Zero,EXE_Result,EXE_Overflow);   	
//������һ����ˮ�εĿ����ź�
//�½��ش������ݺ��ź�
RegEXE regexe(clk,run,
			EXE_RegWr,EXE_Rw,EXE_Result,EXE_MemWr,EXE_busB,EXE_MemtoReg,EXE_Rd,
			MEM_RegWr,MEM_Rw,MEM_Result,MEM_MemWr,MEM_busB,MEM_MemtoReg,MEM_Rd);

//MEM
MEM mem(clk,EXE_MemWr,MEM_Result,MEM_busB,MEM_DataOut);		//�洢����result��Ϊaddress
mux2to1 mux3(MEM_Result,MEM_DataOut,MEM_MemtoReg,MEM_busW);      // ����Ľ����ALU�Ľ�����Ǵ洢���Ľ��
//���ݿ����ź�
RegMEM regmem(clk,run,
			MEM_RegWr,MEM_Rw,MEM_busW,
			Wr_RegWr,Wr_Rw,Wr_busW);
			
//WR
//WrReg wrreg(clk,Wr_RegWr,Wr_Rw,Wr_busW);	
//�����ض����½���д
always@(negedge clk)
begin
	if(Wr_RegWr)
			REG_Files[Wr_Rw]<=Wr_busW;
end

endmodule