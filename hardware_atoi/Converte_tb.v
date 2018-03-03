`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:09:06 03/03/2018
// Design Name:   Converter
// Module Name:   E:/verilog_practice/hardware_atoi/Converte_tb.v
// Project Name:  hardware_atoi
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Converter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Converte_tb;
    
    parameter INPUT_WIDTH = 16;
    parameter OUTPUT_WIDTH = 64;
    parameter CLK_CYCLE = 10;
	// Inputs
	reg [INPUT_WIDTH-1:0] data;
	reg sop;
	reg eop;
	reg rst;
	reg clk;

	// Outputs
	wire [OUTPUT_WIDTH-1:0] number;
	wire valid;
	wire error;

	// Instantiate the Unit Under Test (UUT)
	Converter #(.INPUT_WIDTH(INPUT_WIDTH), .OUTPUT_WIDTH(OUTPUT_WIDTH)) uut(
		.data(data), 
		.sop(sop), 
		.eop(eop), 
		.rst(rst), 
		.clk(clk), 
		.number(number), 
		.valid(valid), 
		.error(error)
	);

	initial begin
		// Initialize Inputs
		data = 0;
		sop = 0;
		eop = 0;
		rst = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        rst = 1;
        #100;
        rst = 0;
        #22;
        sop = 1;
        data = 10;
        #10
        sop = 0;
        data = 49;
        #10
        data = 54;
        #10
        data = 51;
        eop = 1;
        #10
        eop = 0;
        #50
        sop = 1;
        data = 12;
        #10
        sop = 0;
        data = 59;
        #10
        data = 55;
        #10
        data=50;
        eop = 1;
        #10
        eop = 0;
        sop = 1;
        data = 8;
        #10
        sop = 0;
        data = 55;
        #30
        eop = 1;
        #10
        eop = 0;
        sop = 1;
        data = 10;
        #10
        sop = 0;
        data = 49;
        #10
        data = 58;
        #10
        data = 57;
        eop = 1;
        #10
        eop = 0;
        
		// Add stimulus here
	end
    
    always 
        #(CLK_CYCLE/2) clk <= ~clk;
      
endmodule

