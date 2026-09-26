`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2026 11:27:34 PM
// Design Name: 
// Module Name: buardrate_generator
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


module buardrate_generator(
input clk,
input rst,
output tx_en,
output rx_en);

reg [12:0] counter_tx ;
reg [9:0] counter_rx;

always @(posedge clk or posedge rst)
begin
    if (rst)
        counter_tx <= 13'd0;
    else if (counter_tx == 5208)
        counter_tx <=13'd0;
    else
        counter_tx <= counter_tx + 1'b1;
end
always @(posedge clk or posedge rst)
begin
    if (rst)
        counter_rx <= 10'd0;
    else if (counter_rx == 325)
        counter_rx <= 10'd0;
    else
        counter_rx <= counter_rx + 1'b1;
end     

assign tx_en = (counter_tx == 0 )?1'b1:1'b0; 
assign rx_en = (counter_rx == 0 )?1'b1:1'b0;  

endmodule
