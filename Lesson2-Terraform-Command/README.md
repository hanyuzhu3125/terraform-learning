# Terraformのコマンド

以下は、Terraform CLI (バージョン 1.x 系以降) で利用できる主なサブコマンドを目的別にまとめた一覧です。†

---

# よく利用するコマンド

## **terraform init**

`terraform init` は、Terraform プロジェクトの初期化を行うコマンドです。このコマンドは以下の処理を実行します：

1. プロバイダーのダウンロードとインストール
2. バックエンドの初期化
3. モジュールのダウンロード

## **terraform plan**

`terraform plan` は、現在の状態から目的の状態への変更内容を確認するコマンドです。実際のインフラには変更を加えず、どのような変更が行われるかをプレビューできます。

## **terraform apply**

`terraform apply`は、実際にインフラストラクチャに変更を適用するコマンドです。

実行すると、まず`plan`の結果が表示され、続行の確認が求められます。
`yes`を入力すると、実際の変更が開始されます。

## **terraform fmt**

`terraform fmt`は、Terraform の設定ファイルを標準的なフォーマットに整形するコマンドです。

このコマンドは：

- インデントの調整
- 改行の統一
- スペースの調整

などを自動的に行い、コードの可読性を向上させます。チーム開発時には、コードレビュー前にこのコマンドを実行することをお勧めします。

## terraform destroy

`terraform destroy`は、Terraform の管理対象リソースを一括削除するコマンドです。

仕組みは`terraform apply` と同じプラン生成エンジンを使い、**変更差分が “削除のみ”** になる実行プランを内部的に作成し適用します。

実行すると `terraform apply` と同様の対話プロンプトが出て **yes** を求められます。

# 参考内容：

## 1. 初期化・セットアップ

| コマンド | 役割 (ひとこと概要) |
| --- | --- |
| `terraform init` | プロジェクトを初期化し、バックエンドやプロバイダー・モジュールをダウンロード |
| `terraform login` / `logout` | Terraform Cloud / Enterprise への認証トークンを管理 |
| `terraform providers` | 依存するプロバイダーとバージョンを表示 |

## 2. 開発ワークフロー

| コマンド | 役割 |
| --- | --- |
| `terraform fmt` | HCL コードの自動整形 |
| `terraform validate` | 構文・内部整合性チェック |
| `terraform plan` | 実行プランを作成・差分を確認 |
| `terraform apply` | プランを適用し、インフラを変更 |
| `terraform destroy` | 管理対象リソースを一括削除 |

## 3. 実行後の確認・可視化

| コマンド | 役割 |
| --- | --- |
| `terraform show` | 最新状態ファイルまたは plan ファイルを人が読める形で表示 |
| `terraform graph` | 依存グラフを DOT 形式で出力（可視化ツールに渡すと便利） |
| `terraform output` | `output` ブロックで定義した値を取得 |
| `terraform console` | インタラクティブに HCL 変数や関数を評価 |

## 4. ステート管理

| コマンド | 役割 |
| --- | --- |
| `terraform state list` / `show` / `rm` / `mv` | ステートファイル内エントリの列挙・詳細表示・削除・移動 |
| `terraform refresh` | 実際のクラウド側の状態とステートを再同期 |
| `terraform import` | 既存リソースをステートに取り込み |
| `terraform force-unlock` | ロック解除（例：異常終了でロックが残ったとき） |

## 5. ワークスペース

| コマンド | 役割 |
| --- | --- |
| `terraform workspace new` / `select` / `list` / `delete` | 環境ごとのステートを分離（dev/stg/prod など） |

## 6. トラブルシューティング

| コマンド | 役割 |
| --- | --- |
| `terraform state push` / `pull` | 手動でステートをアップロード・取得（バックエンド移行時など） |
| `terraform debug` (隠しフラグ `TF_LOG`) | 詳細ログの出力により問題解析 |

## 7. メタ情報

| コマンド | 役割 |
| --- | --- |
| `terraform version` | Terraform 本体とプラグインのバージョン表示 |
| `terraform -help` / `<cmd> -help` | グローバル・各コマンドのヘルプ |

---

† **備考**

- ここに挙げたものが日常的に使う主なコマンドです。`taint/untaint` など旧式フロー向けのサブコマンドは、近年は `replace` や `target` オプションで代替されるケースが増えています。
- Terraform は **init → validate → plan → apply** というループが基本ワークフローです。適宜 `fmt` でコードを整形し、`state` 系や `workspace` 系コマンドで環境を分離・保守します。