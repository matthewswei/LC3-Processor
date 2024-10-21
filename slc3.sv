//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 5 Given Code - SLC-3 top-level (Physical RAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//------------------------------------------------------------------------------

`include "SLC3_2.sv"
import SLC3_2::*;

module slc3(
	input logic [9:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [9:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);


// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules

assign LED[9:0] = IR[9:0];

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;

//assign hex_4[0][3:0] = IR[3:0];
//assign hex_4[1][3:0] = IR[7:4];
//assign hex_4[2][3:0] = IR[11:8];
//assign hex_4[3][3:0] = IR[15:12];


// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;
// Connect everything to the data path (you have to figure out this part)
datapath d0 (.*);

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)
Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    //.HEX0(), .HEX1(), .HEX2(), .HEX3(),
	 .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);

// SRAM WE register
//logic SRAM_WE_In, SRAM_WE;
//// SRAM WE synchronizer
//always_ff @(posedge Clk or posedge Reset_ah)
//begin
//	if (Reset_ah) SRAM_WE <= 1'b1; //resets to 1
//	else 
//		SRAM_WE <= SRAM_WE_In;
//end

	
endmodule

module datapath (input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
						GatePC, GateMDR, GateALU, GateMARMUX,
						SR2MUX, ADDR1MUX, MARMUX,
						MIO_EN, DRMUX, SR1MUX,
						Clk, Reset,
						input logic [1:0] PCMUX, ADDR2MUX, ALUK,
						input logic [15:0] MDR_In,
						output logic BEN,
						output logic [15:0] MAR, MDR, IR, PC
					);
		
		logic [15:0] value, MDR_IN, PC_IN;
		logic [15:0] ALU;
		logic [2:0] sr1mux_out, drmux_out, nzp_out;
		logic [15:0] sr1reg_out, sr2reg_out, sr2mux_out, addr1_out, addr2_out;
		
		bus path (.Q(value), .*);
		mdr_mux mdrmux (.MIO_EN(MIO_EN), .MDR_IN(value), .mdr_in(MDR_In), .mdr(MDR_IN));
		pc_mux pcmux (.PCMUX(PCMUX), .one(PC), .two(value), .three(addr1_out + addr2_out), .q(PC_IN));
		sr1_mux sr1mux (.IR(IR), .S(SR1MUX), .Q(sr1mux_out));
		dr_mux drmux (.IR(IR), .S(DRMUX), .Q(drmux_out));
		sr2_mux sr2mux(.SR2_OUT(sr2reg_out), .IR(IR), .S(SR2MUX), .Q(sr2mux_out));
		addr1_mux addr1mux (.PC(PC), .SR1OUT(sr1reg_out), .S(ADDR1MUX), .Q(addr1_out));
		addr2_mux addr2mux (.IR(IR), .S(ADDR2MUX), .Q(addr2_out));
		
		ben benreg (.nzp(nzp_out), .IR(IR[11:9]), .LD_BEN(LD_BEN), .Clk(Clk), .BEN(BEN));
		nzp nzpreg (.D(value), .Clk(Clk), .LD_CC(LD_CC), .Q(nzp_out));
		
		register_file regfile (.DRMUX(drmux_out), .SR1MUX(sr1mux_out), .SR2(IR[2:0]), .D(value), 
									.LD_REG(LD_REG), .Clk(Clk), .Reset(Reset), .SR1_out(sr1reg_out), .SR2_out(sr2reg_out));
				
		alu alumod (.A(sr1reg_out), .B(sr2mux_out), .S(ALUK), .Q(ALU));
		reg16 mar (.*, .ld(LD_MAR), .D(value), .Q(MAR));
		reg16 mdr (.*, .ld(LD_MDR), .D(MDR_IN), .Q(MDR));
		reg16 ir (.*, .ld(LD_IR), .D(value), .Q(IR));
		reg16 pcreg (.*, .ld(LD_PC), .D(PC_IN), .Q(PC));
					
endmodule

module bus (input logic GateMDR, GateALU, GatePC, GateMARMUX,
			input logic [15:0] addr1_out, addr2_out,
						input logic [15:0] MAR, MDR, PC, ALU,
						output logic [15:0] Q);
			
		always_comb
			begin
				if(GateMDR)
				begin
					Q = MDR;
				end
				else if(GateALU)
				begin
					Q = ALU;
				end
				else if(GatePC)
				begin
					Q = PC;
				end
				else if(GateMARMUX)
				begin
					Q = addr1_out + addr2_out;
				end
				else
				begin
					Q = 16'b0000000000000000;
				end
			end

endmodule
