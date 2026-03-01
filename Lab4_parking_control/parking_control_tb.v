`timescale 1ns / 1ps

module parking_control_tb();

    // 參數定義
    parameter CNT_MAX_TB = 27'd100;

    reg clk;
    reg switch0, switch1;
    reg pushbutton1, pushbutton2;
    wire LED;

    // 實例化
    parking_control #(
        .CNT_MAX(CNT_MAX_TB)
    ) uut (
        .clk(clk),
        .switch0(switch0),
        .switch1(switch1),
        .pushbutton1(pushbutton1),
        .pushbutton2(pushbutton2),
        .LED(LED)
    );

    // 200MHz Clock
    initial clk = 0;
    always #2.5 clk = ~clk;
    initial begin
        $fsdbDumpfile("parking_control.fsdb");
        $fsdbDumpvars(0, parking_control_tb, "+all");
    end
    initial begin
        // --- 初始化 ---
        switch0 = 0; switch1 = 0;
        pushbutton1 = 0; pushbutton2 = 0;

        $display("=== 模擬開始 ===");

        // ==========================================
        // 第一階段：測試 Drive-in -> 密碼開門
        // ==========================================
        $display("\n[步驟 1] 測試 Drive-in 路徑 (需確保訊號夠長)");

        // 1. 等待進入 car_drivein
        @(posedge uut.tick_0_5s);
        #10; // 避開邊緣
        
        // 2. 按下 PB1 (重點：按久一點)
        pushbutton1 = 1;
        $display("   -> 按下 PB1 (Hold)");
        
        // 等待 tick 觸發跳轉
        @(posedge uut.tick_0_5s);
        
        // 【關鍵修正】：不要馬上放開，多等一下確保 setup time
        #20; 
        pushbutton1 = 0; // 現在才放開
        $display("   -> 放開 PB1 (已進入 enter_password)");

        // 3. 輸入密碼 11 (重點：也要給久一點)
        switch0 = 1; switch1 = 1;
        $display("   -> 輸入密碼 11 (Hold)");
        
        // 等待 tick 觸發跳轉
        @(posedge uut.tick_0_5s);
        
        // 【關鍵修正】：多等一下再清除密碼
        #20; 
        // 此時檢查 LED
        if (LED == 1 && uut.state == 3'd4)
            $display("   [PASS] 密碼正確，LED 亮起 (State=4)");
        else
            $display("   [FAIL] LED 未亮或狀態錯誤 (State=%d)", uut.state);
            
        // 清除密碼
        switch0 = 0; switch1 = 0; 


        // 4. 等待回到 idle
        @(posedge uut.tick_0_5s);
        #10;
        $display("   -> 回到 Idle");
        
        // 稍微休息一下，分隔兩次測試
        #200;


        // ==========================================
        // 第二階段：測試 Drive-off -> 按鈕開門
        // ==========================================
        $display("\n[步驟 2] 測試 Drive-off 路徑");

        // 1. 等待進入 car_drivein
        @(posedge uut.tick_0_5s);
        #10;

        // 2. 保持 PB1=0，等待自動跳轉到 car_driveoff
        // 這裡不需要動作，因為 PB1 已經是 0 了
        $display("   -> 不按 PB1，等待自動跳轉至 Drive-off");
        @(posedge uut.tick_0_5s);
        #10;
        
        if (uut.state == 3'd3) $display("   -> 已進入 car_driveoff (State=3)");

        // 3. 按下 PB2 (重點：按久一點)
        pushbutton2 = 1;
        $display("   -> 按下 PB2 (Hold)");
        
        @(posedge uut.tick_0_5s);
        
        // 【關鍵修正】：多等一下再放開
        #20;
        pushbutton2 = 0;

        // 4. 檢查 LED
        if (LED == 1 && uut.state == 3'd4)
            $display("   [PASS] PB2 觸發，LED 亮起 (State=4)");
        else
            $display("   [FAIL] LED 未亮 (State=%d)", uut.state);

        // 5. 等待回到 idle
        @(posedge uut.tick_0_5s);
        #10;
        $display("   -> 測試結束");

        #100;
        $finish;
    end

endmodule