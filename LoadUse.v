module LoadUse(clk,C,
					ID_EX_MemRead,
					ID_EX_Rt,
					IF_ID_Rs,
					IF_ID_Rt);
input clk;
input ID_EX_MemRead;
input [4:0]ID_EX_Rt;
input [4:0]IF_ID_Rs;
input [4:0]IF_ID_Rt;

output C;
assign C=(ID_EX_MemRead) && ((ID_EX_Rt==IF_ID_Rs) || (ID_EX_Rt==IF_ID_Rt));
/*
always@(posedge clk)
begin
	C=(ID_EX_MemRead) && ((ID_EX_Rt==IF_ID_Rs) || (ID_EX_Rt==IF_ID_Rt));
end*/
endmodule