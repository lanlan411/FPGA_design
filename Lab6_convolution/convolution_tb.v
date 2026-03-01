`timescale 1ns / 1ps

module conv_tb();

    // 定義連接到被測元件 (UUT) 的信號
    reg [3:0] dp;
    wire [3:0] out;

    // 實例化被測元件 (Unit Under Test)
    // 注意：這裡的模組名稱必須與你寫的模組名稱一致
    conv uut_conv (
        .dp(dp),
        .out(out)
    );
    initial begin
        $fsdbDumpfile("conv.fsdb");
        $fsdbDumpvars(0, conv_tb, "+all");
    end
    // 測試流程
    initial begin
        // 顯示標題
        $display("Time\t dp \t out");
        $display("-----------------------");

        // 1. 測試第一個 Kernel (4'b1000)
        dp = 4'b1000;
        #10; // 等待 10ns 讓組合邏輯穩定
        $display("%0t\t %b \t %b", $time, dp, out);

        // 2. 測試第二個 Kernel (4'b0100)
        dp = 4'b0100;
        #10;
        $display("%0t\t %b \t %b", $time, dp, out);

        // 3. 測試第三個 Kernel (4'b0010)
        dp = 4'b0010;
        #10;
        $display("%0t\t %b \t %b", $time, dp, out);

        // 4. 測試第四個 Kernel (4'b0001)
        dp = 4'b0001;
        #10;
        $display("%0t\t %b \t %b", $time, dp, out);

        // 5. 測試預設情況 (Default)
        dp = 4'b0000;
        #10;
        $display("%0t\t %b \t %b", $time, dp, out);

        // 結束模擬
        #10;
        $finish;
    end

endmodule