module mdr_mux (input logic MIO_EN, 
				 input logic [15:0] MDR_IN, mdr_in,
				 output logic [15:0] mdr);
				 
		always_comb
		begin
			case (MIO_EN)
			1'b0 :
				mdr = MDR_IN;
			1'b1 :	
				mdr = mdr_in;
			endcase
		end

endmodule

module pc_mux (input logic [1:0] PCMUX,
				 input logic [15:0] one, two, three,
				 output logic [15:0] q);
		
		always_comb
		begin
			case (PCMUX)
			2'b00 :
				q = one + 1;
			2'b01 : 
				q = two;
			2'b10 :
				q = three;
			default :
				q = 16'bxxxxxxxxxxxxxxxx;
			endcase
		end

endmodule

module sr1_mux (input logic [15:0] IR,
							input logic S,
							output logic [2:0] Q);
		always_comb
		begin
			case (S)
			1'b0:
				Q = IR[11:9];
			1'b1:
				Q = IR[8:6];
			endcase
		end
		
endmodule

module dr_mux (input logic [15:0] IR,
							input logic S,
							output logic [2:0] Q);
		always_comb
		begin
			case (S)
			1'b0:
				Q = IR[11:9];
			1'b1:
				Q = 3'b111;
			endcase
		end

endmodule

module sr2_mux (input logic [15:0] SR2_OUT, IR,
							input logic S,
							output logic [15:0] Q);
		always_comb
		begin
			case (S)
			1'b0 :
				Q = SR2_OUT;
			1'b1 :
				if (IR[4]==1'b0)
					Q = {11'b00000000000, IR[4:0]};
				else
					Q = {11'b11111111111, IR[4:0]};
			endcase
		end
endmodule

module addr1_mux (input logic [15:0] PC, SR1OUT,
						input logic S,
						output logic [15:0] Q);
		always_comb
		begin
			case (S)
			1'b0:
				Q = PC;
			1'b1:
				Q = SR1OUT;
			endcase
		end
		
endmodule

module addr2_mux (input logic [15:0] IR,
						input logic [1:0] S,
						output logic [15:0] Q);
						
		always_comb
		begin
			case (S)
			2'b00:
				Q = 16'h0000;
			2'b01:
				if (IR[5]==1'b0)
					Q = {10'b0000000000, IR[5:0]};
				else
					Q = {10'b1111111111, IR[5:0]};
			2'b10:
				if (IR[8]==1'b0)
					Q = {7'b0000000, IR[8:0]};
				else
					Q = {7'b1111111, IR[8:0]};
			2'b11:
				if (IR[10]==1'b0)
					Q = {5'b00000, IR[10:0]};
				else
					Q = {5'b11111, IR[10:0]};
			endcase
		end
		
endmodule
