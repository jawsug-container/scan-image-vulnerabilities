# Docker イメージ脆弱性診断

[![CircleCI](https://circleci.com/gh/jawsug-container/scan-image-vulnerabilities.svg?style=svg)](https://circleci.com/gh/jawsug-container/scan-image-vulnerabilities)

## 免責事項

本リポジトリは Docker イメージの脆弱性を診断する手法の一例を紹介するものであり  
これらを利用することによって生じたいかなる損害に対しても一切の責任を負いかねます。

## ハンズオン概要

1. [Clair](https://github.com/coreos/clair) と [Trivy](https://github.com/knqyf263/trivy) サーバーを起動
2. Clair 編: [Klar](https://github.com/optiopay/klar) で Docker イメージを脆弱性スキャン
3. Trivy 編: curl で Docker イメージを脆弱性スキャン

## 前提条件

- 端末（Windows, Mac, ..）で Docker が利用できること
- 利用可能な AWS アカウント、Administrator 権限のある IAM ユーザ、そのアクセスキーがあること

### Docker が利用できること

Docker Store からインストーラーをダウンロードし、お手もとの環境へ Docker をインストールしてください。  
Windows へのインストールや動作確認がうまくできない場合は、EC2 の利用をご検討ください。  
（EC2 を利用する場合、パブリック IP アドレスの取得、8080 番ポートの解放が必要です）  

- Mac は [こちら](https://hub.docker.com/editions/community/docker-ce-desktop-mac)
- Windows は [こちら](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- EC2 は [こちら](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/docker-basics.html)

以下のコマンドで、Client と Server の情報が正常に返ってくることを確認してください。

```
$ docker version
```

応答例）

```
Client: Docker Engine - Community
 Version:           18.09.2
 API version:       1.39
 Go version:        go1.10.8
 Git commit:        6247962
 Built:             Sun Feb 10 04:12:39 2019
 OS/Arch:           darwin/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.2
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.6
  Git commit:       6247962
  Built:            Sun Feb 10 04:13:06 2019
  OS/Arch:          linux/amd64
  Experimental:     true
```

### AWS の準備ができていること

#### 1. AWS アカウントの開設

以下のサイトを参考に、AWS アカウントを用意してください。  
https://aws.amazon.com/jp/register-flow/

#### 2. 重要！「AWS 利用開始時に最低限おさえておきたい 10 のこと」の確認

以下の PDF を読み、必要に応じて初期設定を変更してください。  
https://d1.awsstatic.com/webinars/jp/pdf/services/20180403_AWS-BlackBelt_aws10.pdf

#### 3. Administrator 権限のある IAM ユーザと、そのアクセスキーの発行

IAM（Identity and Access Management）とは、AWS でのユーザーや権限を管理するサービスです。  
AWS をより安全に利用するために、初期設定されたルートユーザーとは別に、IAM ユーザーを用意します。

3.1. IAM 管理者ユーザーを作成します

https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/getting-started_create-admin-group.html

3.2. アクセスキーを発行します

発行したアクセスキー・シークレットキーはどこか安全ば場所に保管しておいてください。  
インターネット上に流出させないよう、[git-secrets](https://github.com/awslabs/git-secrets) などをご検討ください。
https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_credentials_access-keys.html

#### 4. EC2 を起動・停止する

AWS では開設直後のアカウントの場合、仮想サーバーの起動数などに制限がかかっていることがあります。  
以下の手順に従い、 **t2.micro** でのインスタンス起動、設定、接続、および終了を一度実行してください。

https://aws.amazon.com/jp/getting-started/tutorials/launch-a-virtual-machine/

## コンテンツ

- [Docker イメージ脆弱性診断](https://github.com/jawsug-container/scan-image-vulnerabilities/blob/master/content/README.md)
