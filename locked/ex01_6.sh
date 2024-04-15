#!/bin/bash

C_FILE=ex01_6.c
EXE_FILE=ex01_6

num_testcases=5

# コンパイル
gcc -o $EXE_FILE $C_FILE

# コンパイルの成功を確認
if [ $? -ne 0 ]; then
    echo "===== 結果: コンパイル失敗 ====="
    echo ""
    exit 1
fi
# 一時ファイルを作成
temp_output="./locked/temp_output.txt"
temp_error="./locked/temp_error.txt"
hash_output="./locked/hash_output.txt"

# テストケースを実行
expect="./locked/cases/${EXE_FILE}/out/0.txt"
"./$EXE_FILE" > $temp_output 2> $temp_error
echo $(cat $temp_output) | tr -d ' \t\n' | shasum -a 256 | awk '{print $1}' > $hash_output

if [ -s "$temp_error" ]; then
    echo "===== 結果: エラー ====="
    echo "$(cat $temp_error)"
    rm "$temp_output" "$temp_error" "$hash_output"
    exit 1
elif ! diff -q $expect $hash_output; then
    echo "===== 結果: 失敗 ====="
    echo "あなたの出力:"
    echo "$(cat $temp_output)"
    rm "$temp_output" "$temp_error" "$hash_output"
    exit 1
fi

echo "===== 結果: 成功 ====="
echo ""

# 一時ファイルを削除
rm "$temp_output" "$temp_error" "$hash_output"