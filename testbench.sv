module testbench();

timeunit 10ns;

timeprecision 1ns;

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

slc3_testtop top(.*);	

logic [15:0] tb_IR, tb_MAR, tb_MDR, tb_PC;
logic [2:0] tb_nzp, tb_ir;
logic tb_BEN, tb_LD_BEN;
logic [4:0] tb_state, tb_next_state;
logic [15:0] tb_reg2, tb_reg7;

assign tb_MAR = top.slc.d0.MAR;
assign tb_IR = top.slc.d0.IR;
assign tb_MDR = top.slc.d0.MDR;
assign tb_PC = top.slc.d0.PC;
assign tb_nzp = top.slc.d0.nzp_out;
assign tb_BEN = top.slc.d0.benreg.BEN;
assign tb_LD_BEN = top.slc.d0.LD_BEN;
assign tb_ir = top.slc.d0.benreg.IR;
assign tb_state = top.slc.state_controller.State;
assign tb_next_state = top.slc.state_controller.Next_state;
assign tb_reg2 = top.slc.d0.regfile.R2out;
assign tb_reg7 = top.slc.d0.regfile.R7out;


always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
	Clk = 0;
end

/*
initial begin: TEST_Five_One
SW = 9'b000000000;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

end
*/

/*
initial begin: TEST_Basic_IO_One
SW = 9'b0000000011;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

end
*/


initial begin: TEST_Basic_IO_Two
SW = 9'b000000110;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;
#2 Run = 1;

#100 SW = 9'b001010010;
#4 Continue = 0;
#4 Continue = 1;

#100 SW = 9'b000001111;
#4 Continue = 0;
#4 Continue = 1;

end


/*
initial begin: TEST_Self_Mod
Continue = 0;
Run = 0;
SW = 16'h000B;

#2 Run = 1;
#2 Run = 0;


#2 Continue = 0;
#2 Continue = 1;

#2 Run = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;	
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;
#100 Continue = 0;
#10 Continue = 1;

end
*/

/*
initial begin: TEST_Auto_Count
SW = 9'b010011100;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

end
*/


/*
initial begin: TEST_XOR
SW = 9'b000010100;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;
#2 Run = 1;

#150 SW = 9'b000001100;
#4 Continue = 0;
#4 Continue = 1;

#150 SW = 9'b000001010;
#4 Continue = 0;
#4 Continue = 1;

end
*/

/*
initial begin: TEST_Mult
SW = 9'b000110001;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;
#2 Run = 1;

#200 SW = 9'b000000010;
#4 Continue = 0;
#4 Continue = 1;

#200 SW = 9'b000000111;
#4 Continue = 0;
#4 Continue = 1;

end
*/

/*
initial begin: TEST_Sort
SW = 9'b001011010;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;
#2 Run = 1;

#600 SW = 9'b000000010;
#50 Continue = 0;
#4 Continue = 1;

#600 SW = 9'b000000011;
#50 Continue = 0;
#4 Continue = 1;

#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;
#7000 Continue = 0;
#4 Continue = 1;

end
*/

/*
initial begin: TEST_Act_Once
SW = 9'b000101010;
Continue = 0;
Run = 0;

#2 Run = 1;
#2 Run = 0;

#2 Continue = 0;
#2 Continue = 1;

#20 Run = 1;
#2 Continue = 0;
#2 Continue = 1;
#2 Run = 0;

end
*/

endmodule
