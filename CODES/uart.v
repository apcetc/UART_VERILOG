`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2026 01:31:32 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input clk,
    input rst,


    input wrt_en,
    input [7:0] data_in,
    output tx,
    output busy,


    input rx,
    input rdy_clr,
    output rdy,
    output parity_error,
    output [7:0] data_out
);

wire tx_en;
wire rx_en;
wire clk;

buardrate_generator baud_gen (
    .clk   (clk),
    .rst   (rst),
    .tx_en (tx_en),
    .rx_en (rx_en)
);


uart_tx transmitter (
    .clk    (clk),
    .wrt_en  (wrt_en),
    .tx_en   (tx_en),
    .rst     (rst),
    .data_in (data_in),
    .tx      (tx),
    .busy    (busy)
);


uart_rx receiver (
    .clk          (clk),
    .rst          (rst),
    .rx           (rx),
    .rdy_clr      (rdy_clr),
    .rx_en        (rx_en),
    .rdy          (rdy),
    .parity_error (parity_error),
    .data_out     (data_out)
);

endmodule