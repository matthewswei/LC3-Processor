module alu (input logic [15:0] A, B,
				input logic [1:0] S,
				output logic [15:0] Q);
	always_comb
	begin
		case (S)
		2'b00:
			Q = A + B;
		2'b01:
			Q = A & B;
		2'b10:
			Q = ~A;
		2'b11:
			Q = A;
		endcase
	end
	
endmodule
