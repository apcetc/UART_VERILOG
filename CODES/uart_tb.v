`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2026 03:37:11 PM
// Design Name: 
// Module Name: uart_tb
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

module uart_tb; 
    reg clk; 
    reg rst;    
    reg        wrt_en; 
    reg [7:0]  data_in;    
    reg        rdy_clr;  
    wire       tx; 
    wire       busy; 
    wire       rdy; 
    wire       parity_error; 
    wire [7:0] data_out; 
    wire rx; 
 assign rx = tx; 
   uart uut ( 
        .clk          (clk), 
        .rst          (rst), 
         .wrt_en       (wrt_en), 
        .data_in      (data_in), 
        .tx            (tx), 
        .busy          (busy), 
         .rx            (rx), 
        .rdy_clr       (rdy_clr), 
        .rdy           (rdy), 
        .parity_error  (parity_error), 
        .data_out      (data_out) 
    ); 
always #5 clk = ~clk;  
    initial 
    begin 
        rst     = 1'b1; 
        wrt_en  = 1'b0; 
        data_in = 8'b0; 
        rdy_clr = 1'b0;          
        #100;  
        rst = 1'b0;  
        #100;  
        data_in = 8'b10101010; 
        wrt_en = 1'b1; 
        #20; 
        wrt_en = 1'b0; 
        if(rdy) 
        begin 
        #10  
        rdy_clr = 1'b1; #10 
        rdy_clr = 1'b0; 
        data_in = 8'b11111111;
        wrt_en = 1'b1;   #20; 
        wrt_en = 1'b0; 
    end 
 end
endmodule 
