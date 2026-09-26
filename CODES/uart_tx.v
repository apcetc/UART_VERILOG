`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2026 11:50:05 PM
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx(
    input clk,
    input wrt_en,
    input tx_en,
    input rst,
    input [7:0] data_in,
    output reg tx,
    output busy
);

parameter idle_state  = 3'b000;
parameter start_state = 3'b001;
parameter data_state  = 3'b010;
parameter parity_state = 3'b011;
parameter stop_state  = 3'b100;

reg [7:0] data;
reg [2:0] index;
reg parity;
reg [3:0] state;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        tx    <= 1'b1;
        state <= idle_state;
        data  <= 8'b0;
        index <= 3'b000;
        parity <= 1'b0;    
    end
    else
    begin
        case(state)

            idle_state:
            begin
                tx <= 1'b1;

                if (wrt_en)
                begin
                    data  <= data_in;
                    parity <= ^data_in;
                    index <= 3'b000;
                    state <= start_state;
                end
            end

            start_state:
            begin
                if (tx_en)
                begin
                    tx    <= 1'b0;
                    state <= data_state;
                end
            end

            data_state:
            begin
                if (tx_en)
                begin
                    tx <= data[index];

                    if (index == 3'b111)
                    begin
                         state <= parity_state;
                    end
                    else
                    begin
                        index <= index + 1'b1;
                    end
                end
            end
            
            parity_state:
                            begin
                                  if(tx_en)
                                    begin
                                       tx <= parity;
                                       state <= stop_state;
                                     end
                            end
            
            stop_state:
            begin
                if (tx_en)
                begin
                    tx    <= 1'b1;
                    state <= idle_state;
                end
            end

            default:
            begin
                tx    <= 1'b1;
                state <= idle_state;
            end

        endcase
    end
end

assign busy = (state != idle_state);

endmodule
