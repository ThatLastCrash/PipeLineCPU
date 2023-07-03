module mux4to1(AluSrc,AluSrcAB,param1,param2,param3,param4,result);
input AluSrc;
input [1:0]AluSrcAB;
input [31:0]param1;
input [31:0]param2;
input [31:0]param3;
input [31:0]param4;
output [31:0]result;

assign result=(AluSrcAB==2'b00)? param1:
				((AluSrcAB==2'b01)? param2:
				((AluSrcAB==2'b10)? param3:param4));
endmodule