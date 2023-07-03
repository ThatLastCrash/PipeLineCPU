module WrReg(CLK,WE,RW,busW);
    parameter ADDR = 5;
    parameter NUMB = 1<<ADDR;
    parameter SIZE = 32;
    
    input CLK;
    input WE;		//写使能
    //input [ADDR:1]RA;	//RB寄存器
    //input [ADDR:1]RB;	//RA寄存器
    input [ADDR:1]RW;	//RW寄存器
    
    input [SIZE:1]busW;	//将要写入RW寄存器
    //output [SIZE:1]busA;	//RA地址处的内容
    //output [SIZE:1]busB;	//RB地址处中的内容
    reg [SIZE:1]REG_Files[0:NUMB-1];
    integer i;
    
    initial
        for(i=0;i<NUMB;i=i+1) REG_Files[i]<=i;
    
    always@(negedge CLK)
    begin
        if(WE)
                REG_Files[RW]<=busW;
    end
    //assign busA=REG_Files[RA];
    //assign busB=REG_Files[RB];

endmodule