`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2026 12:18:43 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input rx_en,

    output reg rdy,
    output reg parity_error,
    output reg [7:0] data_out
);

parameter start_state  = 3'b000;
parameter data_state   = 3'b001;
parameter parity_state = 3'b010;
parameter stop_state   = 3'b011;

reg [2:0] state;
reg [3:0] sample;
reg [2:0] index;
reg [7:0] temp_register;

reg parity;

always @(posedge clk)
begin
    if(rst)
    begin
        state         <= start_state;
        sample        <= 4'd0;
        index         <= 3'd0;
        temp_register <= 8'd0;
        data_out      <= 8'd0;
        rdy           <= 1'b0;
        parity_error  <= 1'b0;
        parity        <= 1'b0;
    end
    else
    begin

        if(rdy_clr)
            rdy <= 1'b0;

        if(rx_en)
        begin
            case(state)

                start_state:
                begin
                    if(rx == 1'b0)
                    begin
                        if(sample == 4'd15)
                        begin
                            state         <= data_state;
                            sample        <= 4'd0;
                            index         <= 3'd0;
                            temp_register <= 8'd0;
                            parity_error  <= 1'b0;
                        end
                        else
                            sample <= sample + 1'b1;
                    end
                    else
                    begin
                        sample <= 4'd0;
                    end
                end

                data_state:
                begin
                    if(sample == 4'd8)
                    begin
                        temp_register[index] <= rx;

                        if(index == 3'd7)
                        begin
                            parity <= ^{temp_register[6:0], rx};

                            state <= parity_state;
                        end
                        else
                        begin
                            index <= index + 1'b1;
                        end
                    end

                    if(sample == 4'd15)
                        sample <= 4'd0;
                    else
                        sample <= sample + 1'b1;
                end

                parity_state:
                begin
                    if(sample == 4'd8)
                    begin
                        if(rx != parity)
                            parity_error <= 1'b1;
                        else
                            parity_error <= 1'b0;
                    end

                    if(sample == 4'd15)
                    begin
                        sample <= 4'd0;
                        state  <= stop_state;
                    end
                    else
                    begin
                        sample <= sample + 1'b1;
                    end
                end

                stop_state:
                begin
                    if(sample == 4'd15)
                    begin
                        if(rx == 1'b1)
                        begin
                            data_out <= temp_register;
                            rdy      <= 1'b1;
                            state  <= start_state;
                            sample <= 4'd0;
                        end


                    end
                    else
                    begin
                        sample <= sample + 1'b1;
                    end
                end


                default:
                begin
                    state  <= start_state;
                    sample <= 4'd0;
                    index  <= 3'd0;
                end

            endcase
        end
    end
end

endmodule
