module MEM(CLK,WE,Address,Data_In,Data_Out);
    parameter NUMB = 256;
    parameter SIZE = 32;
    
    input CLK;
    input WE;
    input [SIZE:1]Data_In;		//写入的数据
    input [SIZE:1]Address;		//地址
    output [SIZE:1]Data_Out;	//读出数据
    
    reg [SIZE:1] Mem[256:0];	//存储器
    
    integer i;
    initial
        for(i=0;i<NUMB;i=i+1) Mem[i]<=i;
    always@(negedge CLK)
    begin
        if(WE)//写入
                Mem[Address]<=Data_In;
    end
    
    assign Data_Out=Mem[Address];
endmodule