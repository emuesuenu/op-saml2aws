#!/bin/bash
set -e
trap 'echo "エラーが発生しました。スクリプトを中断します。"; exit 1' ERR

# 1Password CLIによるサインイン
function signin_1password() {
  local password=$1
  signin_result=$(echo "${password}" | op signin --account ${ONEPASSWORD_ACCOUNT_URL} --raw)
  export OP_SESSION="${signin_result}"
}

# アイテム一覧を取得する
function list_items() {
  op item list --vault "$GOOGLE_WORKSPACE_VAULT" --session "$OP_SESSION" --format=json | \
    jq -r --arg vault_name "$GOOGLE_WORKSPACE_VAULT" --arg title_filter "$GOOGLE_WORKSPACE_ITEM_TITLE" \
      '.[] | select(.vault.name == $vault_name and (.title | contains($title_filter))) | .id'
}

# saml2aws 認証
function authenticate_saml2aws() {
  local item_uuid=$1
  item_details=$(op item get "$item_uuid" --session "$OP_SESSION" --format=json)

  SAML2AWS_USERNAME=$(echo "$item_details" | jq -r '.fields[] | select(.purpose == "USERNAME") | .value')
  SAML2AWS_PASSWORD=$(echo "$item_details" | jq -r '.fields[] | select(.purpose == "PASSWORD") | .value')
  SAML2AWS_MFA_TOKEN=$(echo "$item_details" | jq -r '.fields[] | select(.type == "OTP") | .totp')

  # SAML2AWS 認証コマンドを実行
  saml2aws login --skip-prompt --force \
    --username=${SAML2AWS_USERNAME} \
    --password=${SAML2AWS_PASSWORD} \
    --mfa-token=${SAML2AWS_MFA_TOKEN} \
    --config=${SAML2AWS_CONFIG_FILE}
}

echo "1Passwordへのサインインを開始します..."
# 1Passwordにサインイン
signin_1password "${ONEPASSWORD_MASTER_PASSWORD}"
echo "1Passwordへのサインインが完了しました。"

echo "アイテム一覧の取得を開始します..."
# アイテム一覧を取得
item_uuid=$(list_items)
echo "アイテム一覧の取得が完了しました。"

echo "saml2aws認証を開始します..."
# saml2aws 認証
authenticate_saml2aws "$item_uuid"
echo "saml2aws認証が完了しました。"

echo "スクリプトが正常に完了しました。"
