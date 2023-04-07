# 1Password and saml2aws Authentication Script

このスクリプトは、1Password CLIを使用して1Passwordにサインインし、指定されたアイテムの詳細を取得した後、saml2awsを使用してSAML認証を行います。

環境変数の設定には、direnvコマンドと.envrcファイルを使用することができます。下記の手順に従って、環境変数を設定してください。

## 前提条件

- 1Password CLIがインストールされていること
- saml2awsがインストールされていること
- jqがインストールされていること
- direnvがインストールされていること

## 環境変数の設定方法

1. `.envrc`ファイルをレポジトリの直下に作成し、環境変数の値を設定します。

```
export ONEPASSWORD_ACCOUNT_URL=https://[your account].1password.com/
export ONEPASSWORD_MASTER_PASSWORD=[your password]
export GOOGLE_WORKSPACE_VAULT=Private
export GOOGLE_WORKSPACE_ITEM_TITLE="Google Workspace"
```

2. `direnv allow`コマンドを実行して、`.envrc`ファイルの環境変数を読み込みます。

環境変数が正常に設定されると、スクリプトを実行できます。

## スクリプトの実行方法

1. スクリプトを実行します。`./saml2aws.sh`

スクリプトが正常に実行されると、saml2aws認証が完了し、適切なメッセージが表示されます。
