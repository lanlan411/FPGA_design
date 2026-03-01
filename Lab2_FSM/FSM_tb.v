`timescale 1ns/1ps

module FSM_tb;

    reg clk;
    reg pushbutton0_reset;
    reg pushbutton1_x;
    wire [1:0] LED_state;

    // 實例化 FSM 模組
    // 重要：將計數上限 (CNT_MAX) 改為 4，模擬才會快！
    FSM #(
        .CNT_MAX(27'd4) 
    ) uut (
        .clk(clk),
        .pushbutton0_reset(pushbutton0_reset),
        .pushbutton1_x(pushbutton1_x),
        .LED_state(LED_state)
    );

    // 1. 產生時脈 (100MHz, 週期 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $fsdbDumpfile("FSM.fsdb");
        $fsdbDumpvars(0, FSM_tb, "+all");
    end

    // 2. 測試流程
    initial begin
        // 初始化訊號
        pushbutton0_reset = 1; // 按下 Reset
        pushbutton1_x = 0;     // X = 0 (不計數)
        
        $display("=== Simulation Start ===");
        $monitor("Time=%t | Reset=%b | X=%b | LED=%d", 
                 $time, pushbutton0_reset, pushbutton1_x, LED_state);

        // --- Step 1: 釋放 Reset ---
        #20;
        pushbutton0_reset = 0;
        $display("--- Reset Released ---");

        // 此時 X=0，LED 應該維持在 0
        #50;

        // --- Step 2: 設定 X=1 (開始計數) ---
        // 因為 CNT_MAX=4，LED 應該每 50ns 跳一次 (0->1->2->3->0...)
        pushbutton1_x = 1;
        $display("--- X set to 1, Counter Start ---");
        
        #250; // 觀察幾個循環

        // --- Step 3: 設定 X=0 (暫停) ---
        // LED 應該停在當前的數字，不再跳動
        pushbutton1_x = 0;
        $display("--- X set to 0, Counter Pause ---");
        
        #50;

        // --- Step 4: 再次 Reset ---
        pushbutton0_reset = 1;
        $display("--- Reset Asserted ---");
        #20;
        
        $display("=== Simulation End ===");
        $finish;
    end
endmodule