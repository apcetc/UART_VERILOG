# UART Verilog Implementation

A synthesizable UART transmitter and receiver implemented in Verilog HDL.

## Features

- UART TX and RX
- Configurable baud rate
- 8-bit data
- Start and stop bits
- Parity error detection
- TX busy indication
- RX ready indication
- Verilog testbench
- Simulation verified

## Project Structure

rtl/
  uart_tx.v
  uart_rx.v
  baud_rate_generator.v
  uart.v

sim/
  uart_tb.v
