`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yaojie Lu
// 
// Create Date:    10:41:08 03/03/2018 
// Design Name: 
// Module Name:    Converter 
// Project Name:    Hardware atoi
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/*
 * Hardware atoi module. Works for base 2 to 10. When sop is high, the data input is the  
 * decimal value of the base of this operation. When ascii value given is out of base range,
 * an error will be raised until current operation ends.
 */
module Converter #(parameter INPUT_WIDTH = 8,
                   parameter OUTPUT_WIDTH = 32)(
    input[INPUT_WIDTH-1:0] data,
    input sop,
    input eop,
    input rst,
    input clk,
    output[OUTPUT_WIDTH-1:0] number,
    output valid,
    output error
    );
    
    localparam IDLE = 0;
    localparam WORKING = 1;
    localparam RESULT = 2;
    
    reg[INPUT_WIDTH-1:0] decimal_st1 = 0;
    reg[INPUT_WIDTH-1:0] base = 0;
    reg sop_st1 = 0;
    reg eop_st1 = 0;
    reg rst_sync = 0;
    reg err = 0;
    reg err_next;
    reg[OUTPUT_WIDTH-1:0] result;
    wire[OUTPUT_WIDTH-1:0] result_next;
    reg[1:0] state = IDLE;
    reg[1:0] state_next;
    
    /* Asynchronous reset assertion and synchronous deassertion*/
    always @(posedge clk or posedge rst)
        begin
            if (rst)
                rst_sync <= 1'b1;
            else
                rst_sync <= 1'b0;
        end
    
    /* Reset and clk edge register update logic */
    always @(posedge clk or posedge rst_sync)
        begin
            if (rst_sync)
                begin
                    state <= IDLE;
                    sop_st1 <= 'b0;
                    eop_st1 <= 1'b0;
                    result <= 'd0;
                    err <= 1'b0;
                    base <= 'd0;
                    decimal_st1 <= 'd0;
                end
            else
                begin
                    state <= state_next;
                    result <= result_next;
                    sop_st1 <= sop;
                    eop_st1 <= eop;
                    err <= err_next;
                    /* when sop high, data gives decimal value of base. Otherwise, data is ascii*/
                    if (sop)
                        decimal_st1 <= data;
                    else
                        decimal_st1 <= data - 48;
                    if (sop_st1)
                        base <= decimal_st1;
                        
                end
        end
    
    /* state machine. When sop happens right after eop, state transitions from RESULT to WORKING*/
    always @(*)
        begin
            state_next = IDLE;
            case(state)
            IDLE: state_next = sop_st1?WORKING:IDLE;
            WORKING: state_next = eop_st1?RESULT:WORKING;
            RESULT: state_next = sop_st1?WORKING:IDLE;
            default: state_next = state;
            endcase
        end
    
    /* erro logic. When value bigger than base, error is raised until end of current operation*/
    always @(*)
        begin
            err_next = err;
            if (state != WORKING)
                err_next = 'b0;
            else if (decimal_st1 >= base)
                err_next = 'b1;
            else
                err_next = err;
        end
            
    assign valid = (state==RESULT)?'b1:'b0;
    assign result_next = (state==WORKING)?result*base+decimal_st1:'d0;
    assign number = result;
    assign error = err;  
            
endmodule
