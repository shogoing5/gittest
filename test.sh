#!/bin/bash

# ファイルサーバの接続情報
HOST="ファイルサーバのホスト名またはIPアドレス"
PORT="SFTPのポート番号 (デフォルトは22)"
USERNAME="SFTPのユーザー名"
PASSWORD="SFTPのパスワード"

# ファイルの存在を確認するディレクトリとファイル名
REMOTE_DIR="/リモートディレクトリのパス"
FILE_NAME="確認するファイル名"

# 転送先ディレクトリ
LOCAL_DIR="/ローカルディレクトリのパス"

# 確認する間隔（秒）
CHECK_INTERVAL=60

while true; do
  # ファイルの存在を確認
  sshpass -p "$PASSWORD" sftp -oPort=$PORT $USERNAME@$HOST <<EOF
  cd $REMOTE_DIR
  ls $FILE_NAME
  bye
EOF

  # ステータスコードをチェックしてファイルが存在する場合は転送
  if [[ $? -eq 0 ]]; then
    echo "ファイルが見つかりました。転送を開始します。"

    # ファイルを転送
    sshpass -p "$PASSWORD" sftp -oPort=$PORT $USERNAME@$HOST <<EOF
    cd $REMOTE_DIR
    get $FILE_NAME $LOCAL_DIR
    bye
EOF

    echo "転送が完了しました。"

    # ファイルの転送後に終了する場合は、以下のコメントアウトを解除します。
    # break
  else
    echo "ファイルは存在しませんでした。"
  fi

  sleep $CHECK_INTERVAL
done
上記のスクリプトでは、HOST、PORT、USERNAME、PASSWORD の値を適切な値に設定してください。また、REMOTE_DIR と FILE_NAME を確認したいファイルの場所に合わせて設定してください。LOCAL_DIR はファイルを転送するディレクトリのパスを指定します。

スクリプトは無限ループで実行され、指定した間隔（秒）でファイルの存在を確認します。ファイルが存在する場合は、SFTPを使用してファイルをダウンロードします。ファイルの転送後にスクリプトを終了する場合は、コメントアウトされた break 文を解除してください。

このスクリプトを実行するには、sshpass パッケージが必要です。必要なパッケージをインストールしていない場合は、事前にインストールしてください。また、セキュリティ上の理由から、パスワードをスクリプトに直接書くのは推奨されません。代わりに、SSHキーペアを生成し、パスワードなしでのSFTP接続を設定することをお勧めします。






