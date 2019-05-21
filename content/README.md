# Docker イメージ脆弱性診断

この Git リポジトリを clone する必要はありませんし、任意のディレクトリで動作します。  
Docker クライアントを操作できる端末を起動し、以下のステップを実行してください。  
（EC2 で実行する方は 8080 ポートを解放してください）

## ハンズオン環境の起動

### 1. アクセスキーをそれぞれ変数に設定します

ハンズオン環境に持ち込みたい AWS クレデンシャル情報を設定します。  
（Switch Role したい方は設定ファイルと AWS_DEFAULT_PROFILE を指定してください）

```
$ export AWS_ACCESS_KEY_ID=<あなたの AWS アクセスキー>
$ export AWS_SECRET_ACCESS_KEY=<あなたの AWS シークレットキー>
```

### 2. ハンズオン環境の設定置き場を作ります

```
$ docker volume create scan-images
```

### 3. ハンズオン環境を起動します

```
$ docker run --rm -it -e AWS_DEFAULT_REGION=ap-northeast-1 \
     -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_PROFILE \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v scan-images:/root/config \
     -v $HOME/.aws:/root/.aws \
     -p 8080:8080 jawsug/container:scan-images-fixed
```

### 4. ブラウザで環境に接続します

ブラウザで http://localhost:8080 を開いてください。  
（EC2 を利用している場合は、localhost を EC2 のパブリック IP アドレスに読み替えてください）

パスワードを聞かれるので **jawsug** と入力してください。

### 5. ハンズオンの実施

ハンズオンはブラウザ内の Jupyter notebook で行います。  
以下の順序でハンズオンを進めてください。

```
- 00-overview.ipynb
- 01-provision-aws-resources.ipynb
- 02-clair-and-klar.ipynb
- 03-trivy.ipynb
- 04-teardown-resources.ipynb
```

### 6. 後片付け

`Ctrl + C` でコンテナに停止シグナルを送ると、Jupyter notebook から  
`Shutdown this notebook server (y/[n])?` と聞かれます。  
`y` と入力してコンテナを終了しましょう。

最後に設定を保存したボリュームを削除します。

```
$ docker volume rm scan-images
```
