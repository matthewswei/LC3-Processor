module reg16(input logic Clk, Reset, ld,
				 input logic [15:0] D,
					output logic [15:0] Q);

		always_ff @ (posedge Clk or posedge Reset)
		begin
			if (Reset)
				Q <= 16'b0000000000000000;
			else if (ld)
				Q <= D;
		end
		
endmodule

module ben(input logic [2:0] nzp, IR,
				input logic LD_BEN, Clk,
				output logic BEN);
				
		always_ff @ (posedge Clk)
		begin
			if (LD_BEN)
				BEN <= (IR[2] & nzp[2]) | (IR[1] & nzp[1]) | (IR[0] & nzp[0]);
		end

endmodule

module nzp(input logic [15:0] D,
			input logic LD_CC, Clk,
			output logic [2:0] Q);

		logic [2:0] nzp_out;

		always_ff @ (posedge Clk) 
		begin
			if (LD_CC)
				Q <= nzp_out;
		end

		always_comb 
		begin
			if (D==16'h0000)
				nzp_out = 3'b010;
			else if (D[15]==0)
				nzp_out = 3'b001;
			else if (D[15]==1)
				nzp_out = 3'b100;
			else
				nzp_out = 3'bxxx;
		end

endmodule