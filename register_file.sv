module register_file(input logic [2:0] DRMUX, SR1MUX, SR2,
							input logic [15:0] D,
							input logic LD_REG,Clk, Reset,
							output logic [15:0] SR1_out, SR2_out);
							
		logic[15:0] R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out;
		logic LD_REG0, LD_REG1, LD_REG2, LD_REG3, LD_REG4, LD_REG5,LD_REG6 ,LD_REG7;
		
		always_comb
		begin
				LD_REG0 = 1'b0;
				LD_REG1 = 1'b0;
				LD_REG2 = 1'b0;
				LD_REG3 = 1'b0;
				LD_REG4 = 1'b0;
				LD_REG5 = 1'b0;		
				LD_REG6 = 1'b0;
				LD_REG7 = 1'b0;
			if(LD_REG)
			begin
				case (DRMUX)
				3'b000:
					LD_REG0 = 1'b1;
				3'b001:
					LD_REG1 = 1'b1;
				3'b010:
					LD_REG2 = 1'b1;
				3'b011:
					LD_REG3 = 1'b1;
				3'b100:
					LD_REG4 = 1'b1;
				3'b101:
					LD_REG5 = 1'b1;
				3'b110:		
					LD_REG6 = 1'b1;
				3'b111:
					LD_REG7 = 1'b1;
				endcase
			end
		end
		
		always_comb
		begin
			case (SR1MUX)
				3'b000:
					SR1_out = R0out;
				3'b001:
					SR1_out = R1out;			
				3'b010:
					SR1_out = R2out;
				3'b011:
					SR1_out = R3out;
				3'b100:
					SR1_out = R4out;
				3'b101:
					SR1_out = R5out;
				3'b110:		
					SR1_out = R6out;
				3'b111:
					SR1_out = R7out;
			endcase
				
			case (SR2)
				3'b000:
					SR2_out = R0out;
				3'b001:
					SR2_out = R1out;			
				3'b010:
					SR2_out = R2out;
				3'b011:
					SR2_out = R3out;
				3'b100:
					SR2_out = R4out;
				3'b101:
					SR2_out = R5out;
				3'b110:		
					SR2_out = R6out;
				3'b111:
					SR2_out = R7out;
			endcase 
		end

		reg16 R0(.*, .ld(LD_REG0), .Q(R0out));
		reg16 R1(.*, .ld(LD_REG1), .Q(R1out));
		reg16 R2(.*, .ld(LD_REG2), .Q(R2out));
		reg16 R3(.*, .ld(LD_REG3), .Q(R3out));
		reg16 R4(.*, .ld(LD_REG4), .Q(R4out));
		reg16 R5(.*, .ld(LD_REG5), .Q(R5out));
		reg16 R6(.*, .ld(LD_REG6), .Q(R6out));
		reg16 R7(.*, .ld(LD_REG7), .Q(R7out));
		
endmodule
