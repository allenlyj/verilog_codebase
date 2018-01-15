`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:54:38 01/07/2018
// Design Name:   mainlogic
// Module Name:   E:/verilog_practice/datacrossclock/maintest.v
// Project Name:  datacrossclock
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mainlogic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mainlogictest;
    parameter TCLK = 15,
              RCLK = 40;
	// Inputs
	reg reset;
	reg [31:0] datain;
	reg rclock;
	reg tclock;
	reg inrequest;
	

	// Outputs
	wire [31:0] dataout;
	wire incapable;
    wire outvalid;

	// Instantiate the Unit Under Test (UUT)
	mainlogic uut (
		.reset(reset), 
		.datain(datain), 
		.rclock(rclock), 
		.tclock(tclock), 
		.inrequest(inrequest), 
		.dataout(dataout), 
		.incapable(incapable), 
		.outvalid(outvalid)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		datain = 0;
		rclock = 0;
		tclock = 0;
		inrequest = 0;

		// Wait 100 ns for global reset to finish
		#100;
        reset = 1;
        #100
        inrequest = 1;
	end
    
    always begin
        #(RCLK/2) rclock = ~rclock;
    end
    
    always begin
        #(TCLK/2) tclock = ~tclock;  
    end
    
    always @(posedge incapable)
    begin
        #2 datain = datain+2;
        inrequest = 1'b1;
        #TCLK inrequest = 1'b0;
    end
    
      
endmodule

