#!/bin/bash

function usage() {
  set -e
  cat <<EOM

  [ Docker イメージ脆弱性診断ハンズオン by JAWS-UG コンテナ支部 ]

  8080 番ポートで待機する Juputer notebook が起動します。
  Docker の操作や Fargate の継続的デリバリーのハンズオンが可能です。

  必要な環境変数:
      AWS_ACCESS_KEY_ID      AWS アクセスキー
      AWS_SECRET_ACCESS_KEY  AWS シークレットキー
      AWS_DEFAULT_REGION     AWS リージョン名
      AWS_DEFAULT_PROFILE    Switch Role する場合（オプション）

  必要なホストからのマウント:
      /var/run/docker.sock   Docker の通信のため
      /root/config           設定ファイルを共有するため
      /root/.aws             Switch Role する場合（オプション）

  例:
      $ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
      $ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
      $ docker run --rm -it -e AWS_DEFAULT_REGION=ap-northeast-1 \\
           -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \\
           -v /var/run/docker.sock:/var/run/docker.sock \\
           -v scan-images:/root/config \\
           -p 8080:8080 jawsug/container:scan-images

  備考:
      Docker イメージ名以降にコマンドを指定することで、任意のコマンドが実行可能です

EOM
}

case "$1" in
  -h|--help|help)
    usage
    exit 2
  ;;
esac

if [ "${AWS_ACCESS_KEY_ID}" = "" ]; then
  echo "環境変数に AWS_ACCESS_KEY_ID が指定されていません"
  exit 1
fi
if [ "${AWS_SECRET_ACCESS_KEY}" = "" ]; then
  echo "環境変数に AWS_SECRET_ACCESS_KEY が指定されていません"
  exit 1
fi
if [ "${AWS_DEFAULT_REGION}" = "" ]; then
  echo "環境変数に AWS_DEFAULT_REGION が指定されていません"
  exit 1
fi

identity=$( aws --region "${AWS_DEFAULT_REGION}" sts get-caller-identity 2>/dev/null )
ret="$?"
if [ "${identity}" = "" ]; then
  echo "AWS アクセスキーが不正です"
  exit "${ret}"
fi

versions=$( docker version )
ret="$?"
if [ "${ret}" != "0" ]; then
  echo "Docker ホストとの通信に問題があります"
  exit "${ret}"
fi

if [ ! -e /root/config/.env ]; then
  cat << EOF > /root/config/.env
export PROJECT_ID=$( python3 -c "import uuid;print(uuid.uuid4())" )
EOF
fi
# shellcheck disable=SC1091
source /root/config/.env

cat << EOT

  ProjectID: ${PROJECT_ID}

  [ AWS 環境情報 ]

  Account:   $( echo "${identity}" | jq -r '.Account' )
  Region:    ${AWS_DEFAULT_REGION}
  IAM User:  $( echo "${identity}" | jq -r '.Arn' )
  AccessKey: $( echo "${identity}" | jq -r '.UserId' )

  [ Docker 情報 ]

  ClientVer: $( echo "${versions}" | sed 's/Docker Engine.*//g' | yq -r '.Client.Version' )
  ServerVer: $( echo "${versions}" | sed 's/Docker Engine.*//g' | yq -r '.Server.Engine.Version' )

EOT

exec "$@"
