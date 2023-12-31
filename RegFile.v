module RegFile(CLK,OP,WE,RW,RA,RB,busW,busA,busB);
    parameter ADDR = 5;
    parameter NUMB = 1<<ADDR;
    parameter SIZE = 32;
    
    input OP;
    input CLK;
    input WE;		//дʹ��
    input [ADDR:1]RA;	//RB�Ĵ���
    input [ADDR:1]RB;	//RA�Ĵ���
    input [ADDR:1]RW;	//RW�Ĵ���
    
    input [SIZE:1]busW;
    output reg[SIZE:1]busA;	//RA��ַ��������
    output reg[SIZE:1]busB;	//RB��ַ���е�����
    reg [SIZE:1]REG_Files[0:NUMB-1];
    integer i;
    
    initial
        for(i=0;i<NUMB;i=i+1) REG_Files[i]<=i;

//�����ض����½���д
    always@(posedge CLK)
    if(OP==0)
    begin
		busA=REG_Files[RA];
		busB=REG_Files[RB];
    end
    always@(negedge CLK)
    begin
        if(WE && OP==1)
                REG_Files[RW]<=busW;
    end
	/*
    assign busA=REG_Files[RA];
    assign busB=REG_Files[RB];
	*/
endmodule