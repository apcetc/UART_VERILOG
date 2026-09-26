UART Verilog Implementation

A synthesizable 8-bit UART transmitter and receiver implemented in Verilog HDL using AMD Vivado. Includes TX, RX, baud-rate generation, parity handling, and simulation testbench.

Project Structure
UART/
├── rtl/
│   ├── uart.v
│   ├── uart_tx.v
│   ├── uart_rx.v
│   └── buardrate_generator.v
├── sim/
│   └── uart_tb.v
└── vivado/
    └── UART.xpr
