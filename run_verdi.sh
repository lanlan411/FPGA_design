#!/bin/bash

# 檢查是否有輸入參數
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run_verdi.sh [testbench_name.v]"
    echo "Example: ./run_verdi.sh counter_tb.v"
    exit 1
fi

TARGET_TB=$1

# 在所有 Lab 子資料夾中尋找目標 Testbench
TB_PATH=$(find . -maxdepth 2 -name "$TARGET_TB")

if [ -z "$TB_PATH" ]; then
    echo "Error: Cannot find '$TARGET_TB' in any Lab directory."
    exit 1
fi

# 取得資料夾路徑與絕對路徑
DIR_PATH=$(dirname "$TB_PATH")
ABS_DIR=$(realpath "$DIR_PATH")

# 根據命名規則推導 RTL 檔名與波形檔名
BASE_NAME=$(basename "$TARGET_TB" _tb.v)
RTL_FILE="${BASE_NAME}.v"
FSDB_FILE="$ABS_DIR/sim/${BASE_NAME}.fsdb"

# 檢查必要的檔案是否存在
if [ ! -f "$ABS_DIR/$RTL_FILE" ]; then
    echo "Error: RTL file ($RTL_FILE) not found in $DIR_PATH"
    exit 1
fi

if [ ! -f "$FSDB_FILE" ]; then
    echo "Error: Waveform file not found at $FSDB_FILE"
    echo "Please run: ./run_labs.sh $TARGET_TB first."
    exit 1
fi

# 進入該 Lab 目錄（Verdi 在原始碼目錄開啟較方便查看路徑）
cd "$DIR_PATH" || exit

# 開啟 Verdi
# -sv: 支援 SystemVerilog 語法
# -ssf: 指定讀取 sim/ 資料夾下的波形檔
echo "========================================"
echo "Opening Verdi for $BASE_NAME..."
echo "Loading waveform from: ./sim/${BASE_NAME}.fsdb"
verdi -sv "$TARGET_TB" "$RTL_FILE" -ssf "./sim/${BASE_NAME}.fsdb" &