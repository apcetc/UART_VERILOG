# UART Verilog Implementation

A synthesizable **UART (Universal Asynchronous Receiver/Transmitter)** implemented in Verilog HDL.

The design includes a UART transmitter, UART receiver, and separate baud-rate/sample-enable generator. The transmitter and receiver support **8-bit data with parity and stop-bit handling**.

## Features

* UART Transmitter (TX)
* UART Receiver (RX)
* 8-bit data transmission and reception
* Start bit and stop bit support
* Even parity generation and checking
* TX busy indication
* RX ready indication
* RX parity error detection
* Separate TX and RX timing enables
* Synthesizable Verilog HDL
* Modular RTL design
* Verilog testbench support

## UART Frame Format

The UART frame used by this implementation is:

```text
Idle | Start | 8-bit Data | Parity | Stop
  1  |   0   |    D0-D7   |   P    |  1
```

Data is transmitted **LSB first**.

Parity is generated using the XOR reduction operator:

```verilog
parity = ^data_in;
```

The receiver performs the corresponding parity check and asserts `parity_error` when the received parity does not match.

## Project Structure

```text
UART/
│
├── rtl/
│   ├── uart.v
│   ├── uart_tx.v
│   ├── uart_rx.v
│   └── buardrate_generator.v
│
└── sim/
    └── uart_tb.v
```

> Note: The module/file is currently named `buardrate_generator`. This can be renamed to `baudrate_generator` for clearer spelling, but the module instantiation must be updated accordingly.

## Module Description

### `uart.v`

Top-level UART module that connects the transmitter, receiver, and baud-rate generator.

#### Transmitter interface

```text
wrt_en  → Start transmission
data_in → 8-bit data to transmit
tx      → UART TX output
busy    → Transmission in progress
```

#### Receiver interface

```text
rx           → UART RX input
rdy_clr      → Clear received-data ready flag
rdy          → Received data available
data_out     → Received 8-bit data
parity_error → Parity error indication
```

### `uart_tx.v`

Implements the UART transmitter using an FSM with the following states:

```text
IDLE
  ↓
START
  ↓
DATA
  ↓
PARITY
  ↓
STOP
  ↓
IDLE
```

The transmitter sends:

1. Start bit (`0`)
2. 8 data bits, LSB first
3. Parity bit
4. Stop bit (`1`)

The `busy` signal remains high while the transmitter is not in the IDLE state.

### `uart_rx.v`

Implements the UART receiver using an FSM with the following states:

```text
START
  ↓
DATA
  ↓
PARITY
  ↓
STOP
  ↓
START
```

The receiver uses the RX enable signal for oversampling and samples the incoming signal near the middle of each UART bit period.

The received byte is placed in `data_out` and `rdy` is asserted after a valid frame is received.

If the received parity bit does not match the calculated parity, `parity_error` is asserted.

### `buardrate_generator.v`

Generates separate timing-enable pulses for the transmitter and receiver.

For a **100 MHz clock**:

```text
TX counter = 5208
RX counter = 325
```

The generated enables are approximately:

```text
TX enable ≈ 100 MHz / 5209 ≈ 19.2 kHz
RX enable ≈ 100 MHz / 326  ≈ 306.7 kHz
```

The RX timing therefore provides approximately **16 samples per transmitted bit**, while the TX timing corresponds approximately to a **19.2 kbaud** transmission rate.

## Design Parameters

| Parameter       |       Value |
| --------------- | ----------: |
| System clock    |     100 MHz |
| Data width      |      8 bits |
| TX divider      |        5208 |
| RX divider      |         325 |
| RX oversampling |        ~16× |
| Parity          | Even parity |
| Start bits      |           1 |
| Stop bits       |           1 |
| Data order      |   LSB first |

## Signals

### Top-Level Ports

| Signal         | Direction | Width | Description      |
| -------------- | --------- | ----: | ---------------- |
| `clk`          | Input     |     1 | System clock     |
| `rst`          | Input     |     1 | Reset            |
| `wrt_en`       | Input     |     1 | Start TX         |
| `data_in`      | Input     |     8 | Data to transmit |
| `tx`           | Output    |     1 | UART TX line     |
| `busy`         | Output    |     1 | TX busy          |
| `rx`           | Input     |     1 | UART RX line     |
| `rdy_clr`      | Input     |     1 | Clear RX ready   |
| `rdy`          | Output    |     1 | RX data ready    |
| `parity_error` | Output    |     1 | Parity error     |
| `data_out`     | Output    |     8 | Received data    |

## Operation

### Transmission

When `wrt_en` is asserted while the transmitter is idle:

```text
data_in
   ↓
UART TX
   ↓
Start → D0 → D1 → D2 → D3 → D4 → D5 → D6 → D7 → Parity → Stop
```

The `busy` signal indicates that a transmission is currently in progress.

### Reception

The receiver continuously monitors the `rx` input for a start bit.

After detecting a start bit, it samples the data bits, parity bit, and stop bit using the RX enable timing.

Once a valid frame is received:

```text
Received byte → data_out
                   ↓
                  rdy = 1
```

The `rdy_clr` input can be used to clear the ready indication.

## Verification

A Verilog testbench is included for simulation and verification of UART transmission and reception.

The testbench can be used to verify:

* Start-bit generation
* 8-bit data transmission
* Parity generation
* Stop-bit generation
* Data reception
* RX ready indication
* TX busy indication
* Parity-error detection

## Tools

The design can be simulated and synthesized using common Verilog HDL tools such as:

* AMD/Xilinx Vivado
* ModelSim
* QuestaSim
* Icarus Verilog

## License

This project is provided for educational and FPGA/RTL design purposes.
