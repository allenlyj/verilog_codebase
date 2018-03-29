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
    task automatic push_string;
    input reg[INPUT_WIDTH-1:0] base;
    input integer length;
    reg[OUTPUT_WIDTH-1:0] result_true;
    integer i;
    begin
        sop = 1;
        data = base;
        result_true = 'd0;
        for (i = 0; i < length; i = i+1) begin
            @(posedge clk);
            #2
            sop = 0;
            if (i == length-1)
                eop = 1;
            else
                eop = 0;
            data = $random%base+48;
            result_true = result_true*base+data-48;
        end
        @ (posedge clk);
        #2 eop = 0;
        @ (posedge valid);
        if (number != result_true)
            $display("Incorrect result\n");
        else
            $display("Correct result:%d\n",result_true);
    end
    endtask
    
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

		// Add stimulus here
        #10
        push_string(8,5);
        push_string(10,4);
        push_string(12,5);
        push_string(2,18);
	end
    
    always 
        #(CLK_CYCLE/2) clk <= ~clk;
      
endmodule

