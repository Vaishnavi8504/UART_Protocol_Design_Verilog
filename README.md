# UART_Protocol_Design_Verilog
Designed and verified a bidirectional UART communication system using Verilog HDL. Implemented independent UART transmitter and receiver modules, integrated two devices for full-duplex serial communication, and verified data transmission using a Verilog testbench and Vivado simulation.
# Bidirectional UART Communication Using Verilog HDL

## Project Overview

This project implements a bidirectional UART communication system using Verilog HDL. It consists of two independent devices, where each device contains a UART transmitter and a UART receiver.

The two devices are connected to each other so that the transmitter of one device is connected to the receiver of the other device. Both devices can transmit data simultaneously, allowing bidirectional communication.

The design is implemented using separate transmitter, receiver, and device modules. A Verilog testbench is used to verify data transmission between the two devices.

## Design Architecture

The project consists of three main RTL modules:

### 1. Transmitter Module (`transmitter_uart.v`)

The transmitter module converts 8-bit parallel input data into serial data.

**Inputs:**
- `clk` – Clock signal.
- `rst` – Active-high asynchronous reset.
- `tx_start` – Starts data transmission.
- `tx_data[7:0]` – 8-bit parallel input data.

**Outputs:**
- `tx` – Serial output data.
- `tx_done` – Indicates completion of transmission.

The transmitter uses a five-state FSM:

| State | Operation |
|---|---|
| IDLE | Waits for the `tx_start` signal. |
| START | Transmits the start bit (logic 0). |
| DATA | Transmits the 8-bit data, starting from the LSB. |
| STOP | Transmits the stop bit (logic 1). |
| CLEANUP | Clears `tx_done` and returns to IDLE. |

A clock counter controls the duration of each transmitted bit. The default value of `clk_per_cycle` is 8.

### 2. Receiver Module (`reciever_uart.v`)

The receiver module receives serial data and converts it into 8-bit parallel data.

**Inputs:**
- `clk` – Clock signal.
- `rst` – Active-high asynchronous reset.
- `rx` – Serial input data.

**Outputs:**
- `rx_data[7:0]` – Received 8-bit parallel data.
- `rx_done` – Indicates completion of reception.

The receiver also uses a five-state FSM:

| State | Operation |
|---|---|
| IDLE | Waits for the serial input to become logic 0. |
| START | Waits for half of the configured bit period. |
| DATA | Samples and stores the 8 data bits, starting from the LSB. |
| STOP | Waits for the configured stop-bit duration. |
| CLEANUP | Clears `rx_done` and returns to IDLE. |

The receiver uses a clock counter to control the sampling interval. After detecting the start bit, it waits for half a bit period before entering the DATA state.

### 3. Device Module (`device.v`)

The device module integrates the transmitter and receiver modules.

Each device can:
- Transmit 8-bit parallel data through its UART transmitter.
- Receive serial data through its UART receiver.
- Indicate transmission completion using `tx_done`.
- Indicate reception completion using `rx_done`.

Two instances of this module are used in the testbench.

## Testbench and Verification (`test_bench_uart.v`)

The testbench verifies bidirectional communication between two device instances.

The transmitter and receiver connections are:

- Device 1 TX → Device 2 RX
- Device 2 TX → Device 1 RX

Both devices transmit data simultaneously.

### Test Data

| Signal | Data |
|---|---|
| Device 1 transmit data | `8'hAF` |
| Device 2 transmit data | `8'hBC` |
| Expected Device 1 received data | `8'hBC` |
| Expected Device 2 received data | `8'hAF` |

The testbench performs the following operations:

1. Initializes the clock, reset, and transmission control signals.
2. Applies reset to both devices.
3. Provides `8'hAF` to Device 1 and `8'hBC` to Device 2.
4. Starts both transmissions simultaneously.
5. Waits for both receivers to assert their `rx_done` signals.
6. Compares the received data with the corresponding transmitted data.
7. Displays the verification result.

## Simulation Results

The design was simulated using AMD Xilinx Vivado.

The waveform shows:
- Simultaneous transmission from both devices.
- Serial data transfer between the connected devices.
- Completion signals from the transmitters and receivers.
- Correct reception of `8'hBC` at Device 1.
- Correct reception of `8'hAF` at Device 2.

Both received data values match the corresponding transmitted data.



## Tools and Technologies

- Verilog HDL
- AMD Xilinx Vivado
- Behavioral Simulation
- Finite State Machine (FSM)
- Testbench-based functional verification

## Project Files

```text
Bidirectional_UART/
│
├── transmitter_uart.v
├── reciever_uart.v
├── device.v
├── test_bench_uart.v
└── README.md
```

## Learning Outcomes

- Implemented UART transmitter and receiver modules using Verilog HDL.
- Designed FSM-based control logic for serial data transmission and reception.
- Used clock counters to control bit timing.
- Integrated transmitter and receiver modules into a reusable device module.
- Verified simultaneous bidirectional data communication using a Verilog testbench.
- Analyzed simulation waveforms to check received data and completion signals.

## Author

Vaishnavi Pathak 
Final-Year Electronics and Telecommunication Engineering Student  
Madhav Institute of Technology and Science, Gwalior
