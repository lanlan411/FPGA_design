#!/bin/bash

# 檢查是否有輸入檔名
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run_labs.sh [testbench_name.v]"
    echo "Example: ./run_labs.sh counter_tb.v"
    exit 1
fi

TARGET_TB=$1

# 在所有 Lab 子資料夾中尋找目標 Testbench
# find 會返回相對路徑，例如 ./Lab1_counter/counter_tb.v
TB_PATH=$(find . -maxdepth 2 -name "$TARGET_TB")

if [ -z "$TB_PATH" ]; then
    echo "Error: Cannot find '$TARGET_TB' in any Lab directory."
    exit 1
fi

# 取得資料夾路徑與絕對路徑
DIR_PATH=$(dirname "$TB_PATH")
ABS_DIR=$(realpath "$DIR_PATH")

# 根據命名規則推導 RTL 檔名
BASE_NAME=$(basename "$TARGET_TB" _tb.v)
RTL_FILE="${BASE_NAME}.v"

# 檢查 RTL 檔案是否存在
if [ ! -f "$ABS_DIR/$RTL_FILE" ]; then
    echo "Error: Corresponding RTL file ($RTL_FILE) not found in $DIR_PATH"
    exit 1
fi

echo "========================================"
echo "Target Found: $TB_PATH"
echo "Processing in directory: $DIR_PATH"

# 建立並進入該 Lab 下的 sim 資料夾
mkdir -p "$DIR_PATH/sim"
cd "$DIR_PATH/sim" || exit

# 執行 xmverilog
# 使用絕對路徑確保編譯器能精確抓到檔案
echo "Running simulation in $DIR_PATH/sim/ ..."
xmverilog "$ABS_DIR/$TARGET_TB" "$ABS_DIR/$RTL_FILE" +access+r

echo "========================================"
echo "Simulation completed. Waveform and logs are in $DIR_PATH/sim/"