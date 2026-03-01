# FPGA Lab 自動化編譯與調適工具使用說明
本專案包含兩個 Shell Script (`run_labs.sh` 與 `run_verdi.sh`)，用於簡化 Cadence xmverilog 編譯與 Verdi 波形查看的流程。
系統採用**目錄隔離**設計，所有模擬產生的暫存檔（如 Log、FSDB）都會自動被整理在各個 Lab 目錄下的 `sim/` 資料夾中。
## run_labs.sh (編譯與模擬腳本)
### 功能說明
此腳本會根據你輸入的Testbench檔名，自動搜尋專案內的對應目錄，建立 `sim/` 資料夾，並執行 `xmverilog` 進行硬體模擬。
### 使用方法
> ./run_labs.sh [Testbench檔名.v]
## run_verdi.sh (開啟波形腳本)
### 功能說明
模擬完成後，此腳本可一鍵開啟 Verdi 圖形介面。它會自動定位到正確的 Lab 目錄，並同步載入 RTL 原始碼、Testbench 以及 `sim/` 內的 `.fsdb` 波形檔。
### 使用方法
> ./run_verdi.sh [Testbench檔名.v]
## 快速上手流程
1. **賦予腳本執行權限 (僅需執行一次)**：
> chmod +x run_labs.sh run_verdi.sh
2. **第一步：執行模擬**
> ./run_labs.sh counter_tb.v
3. **第二步：開啟波形除錯**
> ./run_verdi.sh counter_tb.v
## 目錄結構示意
執行過模擬後的資料夾結構會長這樣：
```
├── run_labs.sh
├── run_verdi.sh
└── Lab1_counter/
    ├── counter.v          
    ├── counter_tb.v       
    └── sim/               
        ├── counter.fsdb   
        └── xmverilog.log  
```
## Lab1 counter
### Objectives
The goal of this lab is to design and implement a specific counter based on the provided state diagram using Verilog HDL.
### State Diagram Analysis
The counter transitions through various 3-bit states based on the input control signal C and a Reset signal.
### State Transition Table
The initial state after Reset is `111`.
| Current State (Q[2:0]) | Input (C) | Next State (D[2:0]) |
| :--- | :---: | :--- |
| **111** (Start) | 1 | 000 |
| **000** | 0 | 001 |
| **001** | 1 | 010 |
| **010** | 0 | 100 |
| **100** | 1 | 101 |
| **101** | 0 | 110 |
| **110** | 1 | 000 |
| **011** | 0 | 100 |
### Logic Sequence
Based on the diagram, the main operational loop is:
`111` (Reset) $\rightarrow$ `000` $\rightarrow$ `001` $\rightarrow$ `010` $\rightarrow$ `100` $\rightarrow$ `101` $\rightarrow$ `110` $\rightarrow$ `000`  
Note: The state `011` is an entry point that jumps to 100 when C=0.

## Lab2 FSM
### Project Overview
The objective of this lab is to design and implement a 4-state Finite State Machine (FSM) using **Xilinx** design tools. The system transitions between states based on a single input and displays the current state via LEDs.
### System Specifications
The design follows the logic illustrated in the provided FSM state diagram.
### Input/Output Mapping
| Hardware Component | Function | Logic Description |
| :--- | :--- | :--- |
| **PB0** | Reset | PB0 = 1: Trigger Reset; PB0 = 0: Normal operation. |
| **PB1** | Input X | Controls the state transition logic. |
| **LED1, LED0** | State Output | Represents the current 2-bit state value (S1, S0). |
### State Transition Table
The FSM consists of four states: `00`, `01`, `10`, and `11`. The initial state upon **Reset** is `00`.
| Current State (S1 S0) | Input (X) | Next State (S1' S0') | Transition Type |
| :---: | :---: | :---: | :--- |
| **00** | 0 | 00 | Self-loop |
| **00** | 1 | 01 | Forward |
| **01** | 0 | 01 | Self-loop |
| **01** | 1 | 10 | Forward |
| **10** | 0 | 10 | Self-loop |
| **10** | 1 | 11 | Forward |
| **11** | 0 | 11 | Self-loop |
| **11** | 1 | 00 | Loop back to start |
### Implementation Requirements
* **Reset Logic**: When `PB0` is high, the state must immediately return to `00`.
* **State Display**: The current state must be represented by `LED1` and `LED0`.
* **Input Control**: Transitions are triggered based on the value of X (represented by PB1).

## Lab3 light_control
### Project Overview
The goal of this lab is to design an automatic control system for car headlights using FPGA. The system adjusts the brightness of the headlights (represented by LEDs) based on the environmental light conditions (simulated by DIP switches).
### Functional Requirements
The system adjusts brightness according to three environmental scenarios:
1. **Daytime (Sunny)**: Headlights are set to **minimum brightness**.
2. **Cloudy**: Headlights are set to **medium brightness**.
3. **Nighttime**: Headlights are set to **full brightness**.
### Parameter Settings
The environmental conditions are controlled by two DIP switches (`SW1`, `SW0`), and the output is displayed through four LEDs (`LED3` to `LED0`).
| Environment | SW1 | SW0 | LED3 | LED2 | LED1 | LED0 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Daytime** | 0 | 0 | 0 | 0 | 0 | 1 |
| **Cloudy** | 0 | 1 | 0 | 0 | 1 | 1 |
| **Nighttime** | 1 | 1 | 1 | 1 | 1 | 1 |
### Implementation Details
* **Inputs**: Two DIP switches (`SW1`, `SW0`) representing the light sensors.
* **Outputs**: Four LEDs (`LED3`, `LED2`, `LED1`, `LED0`) representing the headlight intensity levels.
* **Logic**: The system should implement combinational logic to map the switch states to the corresponding LED patterns as defined in the table above.

## Lab4 parking_control
### Project Overview
The objective of this lab is to design a parking lot entry/exit control system with password verification using **Xilinx** design tools. The system manages a gate (LED) based on vehicle sensors and a specific password input.

### System Architecture
The system simulates a parking lot environment with the following hardware mapping:
* **Gate Control**: Represented by `LED0`.
* **Vehicle Sensors**: 
    * `Sensor1` (Entry): Simulated by push button `PB1`.
    * `Sensor2` (Exit): Simulated by push button `PB2`.
* **Password Input**: Simulated by DIP switches `SW1` and `SW2`.
### Control Logic and Requirements
According to the control flowchart (Figure 2) and specifications:
### Initialization
* The gate is initially **Closed** (`LED0 = 0`).
* The system resets the password input buffer to `00₂`.
### Operation Flow
* **Entry Process**:
    1. If a vehicle is detected at the entrance (`PB1` pressed).
    2. The user must input the correct password via `SW1` and `SW2`.
    3. **Correct Password**: `11₂`.
    4. If the password is correct, the gate opens (`LED0 = 1`).
* **Exit Process**:
    1. If a vehicle is detected leaving at the exit (`PB2` pressed).
    2. The gate opens (`LED0 = 1`).
* **Gate Reset**: After the vehicle passes, the gate returns to the closed state (`LED0 = 0`).
### LED Indicators
| Gate State | LED0 Status |
| :--- | :---: |
| **Open** | 1 (On) |
| **Closed** | 0 (Off) |
### Implementation Notes
* **Password Logic**: The password check should be implemented using combinational logic comparing `SW1` and `SW2` against the constant `11₂`.
* **Sequential Control**: Use a state machine to track whether the system is in "Idle", "Verifying Password", or "Gate Open" states.
* **Sensors**: Ensure the sensors (`PB1`, `PB2`) are properly debounced if testing on physical hardware.
### Completion Sequence
1. Implement the password verification and sensor detection logic in Verilog.
2. Define the Finite State Machine (FSM) to handle the control flow shown in Figure 2.
3. Map the inputs (`PB1`, `PB2`, `SW1`, `SW2`) and output (`LED0`) to the FPGA pins.
4. Verify the system by simulating the password entry and vehicle detection sequences.

## Lab5 stepper_motor_control
### Project Overview
The objective of this lab is to design and implement a stepper motor control system. The system manages the output sequences for clockwise (CW) and counterclockwise (CCW) rotations based on a direction input.
### System Architecture
The design logic is based on the function block diagram shown below.
* **Direction Input**: Controlled by `SW0`.
* **Reset**: Triggered by **Push Button 1**.
* **Output Display**: Two LEDs (`LED1`, `LED0`) represent the current state of the stepper motor sequence.
### State Transition Logic
The system transitions between four states (`00`, `01`, `11`, `10`) every **0.5 seconds**.
### 1. Clockwise (CW) Rotation
* **Condition**: `SW0 = 0`
* **Sequence**: `00` → `01` → `11` → `10` → `00` (Repeat)
* **Timing**: Each state lasts for 0.5 seconds.
### 2. Counterclockwise (CCW) Rotation
* **Condition**: `SW0 = 1`
* **Sequence**: `00` → `10` → `11` → `01` → `00` (Repeat)
* **Timing**: Each state lasts for 0.5 seconds.
### Output Sequence Table
| Direction (SW0) | Mode | State Sequence (LED1, LED0) |
| :--- | :--- | :--- |
| **0** | Clockwise (CW) | 00 → 01 → 11 → 10 → ... |
| **1** | Counterclockwise (CCW) | 00 → 10 → 11 → 01 → ... |
### Implementation Requirements
* **Clock Divider**: Since the FPGA system clock is very fast, a clock divider or counter must be implemented to achieve the **0.5-second** delay between state transitions.
* **Reset Behavior**: Pressing **Push Button 1** must immediately reset the state to `00`.
* **State Machine**: Implement an FSM that changes its next state logic based on the value of the `SW0` input.
### Completion Sequence
1. Implement a clock divider to generate a 2Hz (0.5s) enable signal.
2. Design the FSM logic for both CW and CCW sequences.
3. Assign the physical pins for `SW0`, `Push Button 1`, and `LED1/LED0`.
4. Verify the rotation directions and timing on the FPGA board.

## Lab6 convolution
### Project Overview
The goal of this lab is to design a hardware-based convolution circuit on a Xilinx FPGA. This simulates the core operation of a Convolutional Neural Network (CNN), where a $4 \times 4$ Input Image is processed by a $3 \times 3$ Kernel to produce a $2 \times 2$ Output.
### Mathematical Model
The convolution operation is performed by sliding the Kernel over the Image and calculating the sum of products:
* **Input Image Size**: $4 \times 4$
* **Kernel Size**: $3 \times 3$
* **Output Size**: $2 \times 2$
### Calculation Example
For the first output element ($Output_0$):
$$Output_0 = \sum (Image_{sub} \times Kernel)$$
Example: $15 = (1 \times 2) + (2 \times 0) + (3 \times 1) + (0 \times 0) + (1 \times 1) + (2 \times 2) + (3 \times 1) + (0 \times 0) + (1 \times 2)$
### Hardware Configuration
### Input Image Data
The $4 \times 4$ image pixels are pre-defined as follows:
| 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|
| 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 |
### Kernel Selection (DIP Switch Control)
Four different kernels can be selected using the DIP switches. Each selection updates the `LED0 ~ LED3` status.
| DIP [3:0] | Kernel Type (3x3 Matrix) | Output Indication |
| :--- | :--- | :--- |
| **1000** | Identity / Custom A | LED3 On |
| **0100** | Edge Detection / Custom B | LED2 On |
| **0010** | Sharpen / Custom C | LED1 On |
| **0001** | All-On / Custom D | LED0 On |
### Threshold Comparison & Output
The four output values ($Output_0$ to $Output_3$) are compared against a **Threshold of 40**:
* **If Output Value $\ge$ 40**: The corresponding LED turns **ON**.
* **If Output Value < 40**: The corresponding LED turns **OFF**.

| Hardware Output | Mapped Calculation |
| :--- | :--- |
| **LED0** | Result of $Output_0$ |
| **LED1** | Result of $Output_1$ |
| **LED2** | Result of $Output_2$ |
| **LED3** | Result of $Output_3$ |
### Implementation Details
* **Combinational Logic**: Use multipliers and adders to calculate the four convolution results in parallel.
* **Multiplexing**: Use the DIP switch input as a selector for the Kernel coefficients.
* **Comparison**: Implement four comparators to determine the LED states based on the $Output \ge 40$ condition.
### Completion Sequence
1. Define the $4 \times 4$ image array and four $3 \times 3$ kernel arrays in Verilog.
2. Implement the sum-of-products logic for all four sliding window positions.
3. Integrate the DIP switch logic to switch between kernels.
4. Set the comparison logic for the threshold (40) and map to LEDs.
5. Verify calculations using simulation and hardware test.

## Lab7 line_buffer
### Project Overview
The objective of this lab is to design an adjustable line buffer system using **Xilinx** design tools. The system features a variable buffer width controlled by DIP switches and visualizes the internal register states through LEDs at a fixed frequency.
### System Architecture
The system consists of a sequence of registers ($R_0, R_1, \dots, R_{n-1}$) where data shifts through the buffer at a rate of 1 Hz.
### Hardware Mapping & Controls
| Component | Function | Description |
| :--- | :--- | :--- |
| **DIP [4:1]** | Width Control | Sets the buffer width ($n$) from 2 to 8. |
| **PB0** | Start/Enable | `PB0 = 1`: System starts operating. |
| **PB3** | Reset | `PB3 = 1`: Clears all registers ($R_0 \sim R_{n-1} = 0$). |
| **LED [3:0]** | Status Output | Displays mapped register values based on the layout. |
### Functional Requirements
### Width Configuration
The width ($n$) of the buffer is determined by the binary value of `DIP4, DIP3, DIP2, DIP1`. 
* **Example**: If `DIP4=1` and `DIP3=DIP2=DIP1=0`, the width is set to **8**.
### Operation Logic
* **Clock Frequency**: 1 Hz (Period $T = 1\text{ sec}$).
* **Input Data**: Fixed at logic `1`.
* **Shifting**: At every clock cycle, $Input \rightarrow R_0$, $R_0 \rightarrow R_1$, $\dots$, $R_{n-2} \rightarrow R_{n-1}$.
### LED Visualization Mapping
The LEDs display specific register values depending on the selected width. The buffer is conceptually organized into two rows.
### Example: Width = 8 (2x4 Matrix)
| Row | Column 0 | Column 1 | Column 2 | Column 3 |
| :--- | :---: | :---: | :---: | :---: |
| **Row 1** | $R_0$ (**LED0**) | $R_1$ (**LED1**) | $R_2$ | $R_3$ |
| **Row 2** | $R_8$ (**LED2**) | $R_9$ (**LED3**) | $R_{10}$ | $R_{11}$ |
*(Note: LED assignment follows the vertical boundary shown in Figure 2)*
### Example: Width = 4 (2x2 Matrix)
| Row | Column 0 | Column 1 |
| :--- | :---: | :---: |
| **Row 1** | $R_0$ (**LED0**) | $R_1$ (**LED1**) |
| **Row 2** | $R_4$ (**LED2**) | $R_5$ (**LED3**) |
### Implementation Details
* **Clock Divider**: A clock divider is required to convert the FPGA system clock to a **1 Hz** signal.
* **Variable Shift Register**: Implement a shift register whose effective length changes based on the DIP switch input.
* **Mapping Logic**: Implement combinational logic to route the correct register output to the four LEDs based on the current width setting.
### Completion Sequence
1. Design a 1 Hz clock generator.
2. Implement the adjustable shift register logic with Reset (PB3) and Enable (PB0) functionality.
3. Create the LED mapping table for widths 2 through 8.
4. Verify the shifting behavior (data "filling" the buffer) through the LEDs as shown in the Step-by-Step example.
