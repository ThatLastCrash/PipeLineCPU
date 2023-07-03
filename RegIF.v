module RegIF(clk,run,
				IF_instru,IF_pc,
				ID_instru,ID_pc);
input clk,run;
input [29:0]IF_pc;
input [31:0]IF_instru;

output reg [29:0]ID_pc;
output reg [31:0]ID_instru;

always@(negedge clk)
begin
	if(run==0)
	begin
		ID_pc=IF_pc;
		ID_instru=IF_instru;
	end
end
endmodule