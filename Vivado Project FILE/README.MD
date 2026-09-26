# UART Verilog Implementation

A synthesizable **8-bit UART transmitter and receiver** implemented in Verilog HDL using **AMD Vivado**.

**Features:** TX, RX, baud-rate generation, parity handling, and simulation testbench.

## Project Structure

```text
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
```

## Tools

* Verilog HDL
* AMD Vivado
* ModelSim
