# githubにpushするためのスクリプト
# Usage: ./submit.sh

# 対象ファイルリスト
TARGET_FILES=("ex01_1.c" "ex01_2.c" "ex01_3.c" "ex01_4.c" "ex01_5.c" "ex01_6.c" "ex01_7.c" "ex01_8.c" "ex01_9.c")

# コミットメッセージ
COMMIT_MESSAGE="ex1"

# リモートリポジトリ
REMOTE_REPOSITORY="origin"

# ブランチ
BRANCH_NAME="main"

# ファイルの追加
# 変更があるかどうかを確認
change_check=0
for file in ${TARGET_FILES[@]}; do
    git add $file
    changes=$(git status --porcelain $file)
    if [ -n "$changes" ]; then
        change_check=1
    fi
done

# コミット
# 変更がない場合は何もしない
if [ $change_check -eq 0 ]; then
    echo "変更がありません。"
    exit 0
fi
git commit -m "$COMMIT_MESSAGE"

# プッシュ
git push $REMOTE_REPOSITORY $BRANCH_NAME

# 採点中のメッセージ
echo -n "課題を提出しました。採点中"

# 10秒待機
# sleep 10
for i in {1..10}; do
    echo -n "."
    sleep 1
done

# statusがcompletedになるまで待機
while true; do
    echo -n "."
    status=$(gh run list -L 1 --json 'status' --jq '.[0].status')
    if [ $status = 'completed' ]; then
        break
    fi
    sleep 1
done

# 改行
echo ""

# 最近実行されたワークフローの一覧をJSON形式で取得し、その中から最初のワークフローのIDを取得する
run_id=$(gh run list -L 1 --json 'databaseId' --jq '.[0].databaseId')

# 採点結果を表示
echo "採点結果：" $(gh run view $run_id --log | grep "Total:" | awk -F '│' '{print $3}'  | sed 's/0//g')

# 終了ステータス
exit 0
