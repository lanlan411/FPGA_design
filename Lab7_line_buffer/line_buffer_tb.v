`timescale 1ns / 1ps

module line_buffer_tb();
    // 訊號定義
    reg clk;
    reg rst;
    reg start;
    reg [3:0] sw;
    wire [3:0] leds;

    // 實例化被測元件 (UUT)
    // 透過參數覆蓋 (Parameter Overriding) 將 CNT_MAX 縮小為 10
    // 這樣每 10 個 clock 就會移動一次位元，方便觀察
    line_buffer #(.CNT_MAX(27'd10)) uut (
        .clk(clk),
        .pushbutton3_reset(rst),
        .pushbutton0_start(start),
        .switch(sw),
        .LED_state(leds)
    );

    // 產生時脈：假設為 100MHz (週期 10ns)，每 5ns 反相一次
    always #5 clk = ~clk;
    initial begin
        $fsdbDumpfile("line_buffer.fsdb");
        $fsdbDumpvars(0, line_buffer_tb, "+all");
    end
    initial begin
        // --- 初始化 ---
        clk = 0;
        rst = 1;      // 開啟重置
        start = 0;
        sw = 4'b1000; // 初始選擇 width_select = 4'd2
        
        // --- 釋放重置 ---
        #20 rst = 0;
        #20;

        // --- 測試啟動 (Start) ---
        // 模擬按鈕按下一個短暫脈衝
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        
        $display("系統啟動，開始觀察移位...");

        // --- 觀察 width_select = 2 (顯示 [3:0]) ---
        // 等待足夠的時間讓 line_register 移位 (10 clk * 5 bits = 50 clk)
        repeat (60) @(posedge clk);
        $display("Width 2 輸出: %b", leds);

        // --- 測試切換開關到 width_select = 4 (顯示 [5,4,1,0]) ---
        @(posedge clk);
        sw = 4'b0010;
        #20;
        $display("切換到 Width 4, 輸出: %b", leds);

        // --- 測試切換開關到 width_select = 8 (顯示 [9,8,1,0]) ---
        repeat (50) @(posedge clk); // 再等一下讓更多 1 移入
        sw = 4'b0100;
        #20;
        $display("切換到 Width 8, 輸出: %b", leds);

        // --- 測試重置功能 ---
        #20 rst = 1;
        #20 rst = 0;
        $display("重置後輸出: %b", leds);

        #100;
        $finish;
    end

endmodule