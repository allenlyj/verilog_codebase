`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 01/07/2018 
// Design Name: 
// Module Name:    mainlogic 
// Project Name: 
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
module mainlogic # (parameter DATA_WIDTH=32)
(
    input reset,
    input [DATA_WIDTH-1:0] datain,
    input rclock,
    input tclock,
    input inrequest,
    output [DATA_WIDTH-1:0] dataout,
    output reg incapable,
    output reg outvalid
    );
    
localparam TIDLE = 2'd0,
           TSENDING = 2'd1,
           TFINISHING = 2'd2,
           RIDLE = 2'd0,
           RSENDING = 2'd1,
           RFINISHING = 2'd2;

// Transmitter part signals
reg rack_sync;
reg rack_d1;
reg[1:0] tstate = TIDLE;
reg[1:0] tstate_next;
reg tack;
reg[DATA_WIDTH-1:0] datain_next;
reg[DATA_WIDTH-1:0] datain_registered = {DATA_WIDTH{1'b0}};

//Receiver part signals
reg tack_sync;
reg tack_d1;
reg rack;
reg[1:0] rstate = RIDLE;
reg[1:0] rstate_next;
 

assign dataout = datain_registered;
// Transmitter decision logic
always @(*)
begin
    tack = 1'b0;
    tstate_next = tstate;
    datain_next = datain_registered;
    incapable = 1'b0;
    
    case(tstate)
    TIDLE:
    begin
        incapable = 1'b1;
        if (inrequest)
        begin
            tstate_next = TSENDING;
            datain_next = datain;
        end
    end
    
    TSENDING:
    begin
        tack = 1'b1;
        if (rack_sync)
            tstate_next = TFINISHING;
        else
            tstate_next = TSENDING;
    end
    
    TFINISHING:
    begin
        tack = 1'b0;
        if (rack_sync)
            tstate_next = TFINISHING;
        else
        begin
            incapable = 1'b1;
            if (inrequest)
            begin
                tstate_next = TSENDING;
                datain_next = datain;
            end
            else
                tstate_next = TIDLE;
        end        
    end
    
    default: ;
    endcase
end
              
always @(posedge tclock or negedge reset)
begin
// Tranceiver reset
    if(!reset)
    begin
        tstate <= TIDLE;
        datain_registered <= {DATA_WIDTH{1'b0}};
    end  
    
    else
    begin
        tstate <= tstate_next;
        datain_registered <= datain_next;
        rack_d1 <= rack;
        rack_sync <= rack_d1;
    end
        
end 

// Receiver decision logic
always @(*)
begin
    rstate_next = rstate;
    rack = 1'b0;
    outvalid = 1'b0;
    
    case(rstate)
    RIDLE:
    if (tack_sync)
    begin
        rstate_next = RSENDING;
        outvalid = 1'b1;
    end
    
    RSENDING:
    begin
    rack = 1'b1;
    if (!tack_sync)
        rstate_next = RIDLE;
    end
    
    default:;
    endcase
end
    
always@(posedge rclock or negedge reset)
begin
    if (!reset)
    rstate <= RIDLE;
    else
    begin
        rstate <= rstate_next;
        tack_d1 <= tack;
        tack_sync <= tack_d1;
    end
end

//assign outvalid = (rstate==RIDLE)&tack_sync;
        
endmodule
