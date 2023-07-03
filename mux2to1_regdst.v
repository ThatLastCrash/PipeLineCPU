module mux2to1_regdst(Rt,Rd,RegDst,Rw);
input [4:0] Rt;
input [4:0] Rd;
input RegDst;
output [4:0] Rw;

assign Rw=(RegDst)?Rd:Rt;
endmodule