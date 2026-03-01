`timescale 1ns/1ps

module counter_tb;
    reg clk;
    reg reset;
    reg C;
    wire [2:0] LED_state;

    // 實例化
    counter uut (
        .clk(clk),
        .reset(reset),
        .C(C),
        .LED_state(LED_state)
    );

    // 產生時脈 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $fsdbDumpfile("counter.fsdb");
        $fsdbDumpvars(0, counter_tb, "+all");
    end
    // 測試流程
    initial begin
        // 1. 初始化
        reset = 1;
        C = 0; 
        
        $display("=== Simulation Start ===");
        $monitor("Time=%3dns, Reset=%b, C=%b, State=%d (Binary=%b)", 
                 $time, reset, C, LED_state, LED_state);

        // 2. 釋放 Reset
        // 預期：State 變成 7 (111)
        #15 reset = 0; 
        
        // 此時 State 應為 7。
        // 根據圖：State 7 若 C=1 -> State 0
        #10 C = 1; // 觸發跳轉到 0

        // State 0 若 C=0 -> State 1
        #10 C = 0; 

        // State 1 若 C=1 -> State 2
        #10 C = 1;

        // State 2 若 C=0 -> State 4
        #10 C = 0;

        // State 4 若 C=1 -> State 5
        #10 C = 1;

        // State 5 若 C=0 -> State 6
        #10 C = 0;

        // State 6 若 C=1 -> State 0 (回到循環)
        #10 C = 1;

        // 觀察一下回到 0 之後
        #10;

        $display("=== Simulation End ===");
        $finish;
    end
endmodule