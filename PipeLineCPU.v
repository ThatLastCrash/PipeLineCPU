module PipeLineCPU(clk,run,
		IF_pc,
		IF_instru,           // PC值，取的指令
		IF_addr_mem,
		
		/*
		IF_RegWr,			//寄存器写使能
		IF_Branch,IF_Jump,	//跳转标志
		IF_ExtOP,		//立即数扩展有符号还是无符号
		IF_AluSrc,		//alu数据源选择标志
		IF_MemWr,		//存储器写使能
		IF_MemtoReg,	//最终结果选择标志，1是存储器，0是alu计算结果
		IF_RegDst,		//目的寄存器选择
		IF_AluCtr,  		 // ALU操作控制信号，1是立即数，0是busB
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
		EXE_busOutB,   		 //busB 选择的输出源操作数
		EXE_Result,    		 //ALU的结果
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
		
		MEM_busW,			//寄存器
		MEM_DataOut,		 // 存储器读出来的值
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
		Zero            // 0信号alu的ZF
		//imm16			//立即数 
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
//取指令,在instru中,pc+4在IF_pc中
Instruction ins(clk,C,IF_instru,IF_pc,IF_addr_mem,ID_addr_change);      
//下降沿传递数据和信号
RegIF regif(clk,C,
			IF_instru,IF_pc,ID_instru,ID_pc);


//ID
//取数译码，生成控制信号
Controller con(clk,run,ID_pc,ID_instru,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_MemWr,ID_MemtoReg,ID_RegWr,ID_RegDst,ID_Rs,ID_Rt,ID_Rd,
	ID_addr_change,ID_op,ID_func);
// 确定目的寄存器RW
mux2to1_regdst mux1(ID_Rt,ID_Rd,ID_RegDst,ID_Rw);


//初始化寄存器
reg [32:1]REG_Files[0:32-1];
integer i;

initial
	for(i=0;i<32;i=i+1) REG_Files[i]<=i;

//上升沿读，下降沿写
always@(posedge clk)
begin
	ID_busA=REG_Files[ID_Rs];
	ID_busB=REG_Files[ID_Rt];
end


//得到busA,busB,上升沿读数据和计算
//RegFile rreg(clk,ID_RegWr,ID_Rw,ID_Rs,ID_Rt,ID_busA,ID_busB);	


//loaduse冒险
LoadUse loaduse(clk,C,EXE_MemRead,EXE_Rt,ID_Rs,ID_Rt);
//下降沿传递数据和信号
RegID regid(clk,C,ID_addr_change,
			ID_MemWr,ID_MemtoReg,ID_RegWr,ID_Rw,ID_busA,ID_busB,ID_imm16,ID_ExtOP,ID_AluSrc,ID_AluCtr,ID_Rs,ID_Rt,ID_Rd,ID_op,
			EXE_MemWr,EXE_MemtoReg,EXE_RegWr,EXE_Rw,EXE_busA,EXE_busB,EXE_imm16,EXE_ExtOP,EXE_AluSrc,EXE_AluCtr,EXE_Rs,EXE_Rt,EXE_Rd,EXE_MemRead);


//EXE
signZeroExtend sz(EXE_imm16,EXE_ExtOP,EXE_immOut);  	       // 0,1扩展

//数据冒险，判断是否有冒险，进行A口B口数据更新
DataHazard dataHazard(clk,EXE_AluSrc,C,
						MEM_RegWr,MEM_Rw,
						EXE_Rs,EXE_Rt,
						Wr_RegWr,Wr_Rw,
						AluSrcA,AluSrcB);

//A口三选一，B口四选一
mux4to1 m4to1_A(EXE_AluSrc,AluSrcA,EXE_busA,MEM_Result,Wr_busW,EXE_busA,EXE_busOutA);
//mux2to1 mux2(EXE_busB,EXE_immOut,EXE_AluSrc,EXE_busOutB);                     //busB 选择的输出源操作数，送入alu
mux4to1 m4to1_B(EXE_AluSrc,AluSrcB,EXE_busB,MEM_Result,Wr_busW,EXE_immOut,EXE_busOutB);


//alu运算得出结果在result中
//EXE_busOut是ALU的B口
//上升沿读数据和计算
ALU alu(clk,EXE_busOutA,EXE_busOutB,EXE_AluCtr,Zero,EXE_Result,EXE_Overflow);   	
//传递上一个流水段的控制信号
//下降沿传递数据和信号
RegEXE regexe(clk,run,
			EXE_RegWr,EXE_Rw,EXE_Result,EXE_MemWr,EXE_busB,EXE_MemtoReg,EXE_Rd,
			MEM_RegWr,MEM_Rw,MEM_Result,MEM_MemWr,MEM_busB,MEM_MemtoReg,MEM_Rd);

//MEM
MEM mem(clk,EXE_MemWr,MEM_Result,MEM_busB,MEM_DataOut);		//存储器，result作为address
mux2to1 mux3(MEM_Result,MEM_DataOut,MEM_MemtoReg,MEM_busW);      // 输出的结果，ALU的结果还是存储器的结果
//传递控制信号
RegMEM regmem(clk,run,
			MEM_RegWr,MEM_Rw,MEM_busW,
			Wr_RegWr,Wr_Rw,Wr_busW);
			
//WR
//WrReg wrreg(clk,Wr_RegWr,Wr_Rw,Wr_busW);	
//上升沿读，下降沿写
always@(negedge clk)
begin
	if(Wr_RegWr)
			REG_Files[Wr_Rw]<=Wr_busW;
end

endmodule
