`timescale 1ns / 1ps

module stepper_motor_control_tb();

    // 參數定義：縮短模擬時間 (10個 clk 跳一次)
    parameter CNT_MAX_TB = 27'd10;

    reg clk;
    reg pushbutton1_reset;
    reg switch0;
    wire [1:0] LED_state;

    // 實例化
    stepper_motor_control #(
        .CNT_MAX(CNT_MAX_TB)
    ) uut (
        .clk(clk),
        .pushbutton1_reset(pushbutton1_reset),
        .switch0(switch0),
        .LED_state(LED_state)
    );

    // 200MHz Clock
    initial clk = 0;
    always #2.5 clk = ~clk;
    initial begin
        $fsdbDumpfile("stepper_motor_control.fsdb");
        $fsdbDumpvars(0, stepper_motor_control_tb, "+all");
    end
    initial begin
        // --- 初始化 ---
        pushbutton1_reset = 1; // 一開始先 Reset
        switch0 = 0;
        
        $display("=== 步進馬達控制模擬開始 ===");
        #20; 
        pushbutton1_reset = 0; // 放開 Reset
        $display("T=%t | Reset 釋放，初始狀態: %b", $time, LED_state);

        // ==========================================
        // 測試 1: Switch0 = 0 (正轉)
        // 預期序列: 00 -> 01 -> 11 -> 10 -> 00
        // ==========================================
        $display("\n[測試 1] 正轉測試 (Switch0 = 0)");
        switch0 = 0;

        repeat(5) begin
            @(posedge uut.tick_0_5s); // 等待 tick
            #1; // 避開邊緣觀察
            $display("T=%t | State: %b (正轉中)", $time, LED_state);
        end

        // ==========================================
        // 測試 2: Switch0 = 1 (反轉)
        // 預期序列: 00 -> 10 -> 11 -> 01 -> 00
        // ==========================================
        $display("\n[測試 2] 反轉測試 (Switch0 = 1)");
        switch0 = 1;

        repeat(5) begin
            @(posedge uut.tick_0_5s);
            #1;
            $display("T=%t | State: %b (反轉中)", $time, LED_state);
        end

        // ==========================================
        // 測試 3: 運作中非同步 Reset
        // ==========================================
        $display("\n[測試 3] 運作中按下 Reset");
        #15; // 在兩個 tick 中間按下
        pushbutton1_reset = 1;
        #5;
        $display("T=%t | Reset 按下! State: %b (應為 00)", $time, LED_state);
        
        if(LED_state == 2'b00) 
            $display("   [PASS] Reset 成功");
        else 
            $display("   [FAIL] Reset 失敗");

        pushbutton1_reset = 0;
        #50;
        $finish;
    end

endmodule