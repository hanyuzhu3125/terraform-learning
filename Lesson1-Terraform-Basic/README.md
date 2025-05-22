# Terraformの基礎

## Terraformとは

TerraformはHashiCorp社が開発したオープンソースのインフラストラクチャ自動化ツールです。インフラストラクチャをコード（IaC: Infrastructure as Code）として記述することで、クラウド環境やオンプレミス環境のリソースを効率的に管理・構築できます。

## Terraformの基本概念

### **Configuration Language**

- **HCL (HashiCorp Configuration Language)** を採用。JSON 互換だが、人が読み書きしやすい宣言型シンタックス。
- **resource / data / variable / output / locals / terraform** などのブロックで構成。
- **依存関係** は変数参照（`aws_instance.web.id` のような階層参照）で暗黙的に解決され、DAG を自動生成。
- **ループ・条件分岐** には `for` 式、`for_each`、`count`、`dynamic` ブロック、`if` 式が利用可能。

### Commands

| よく使うコマンド | 目的（要点） |
| --- | --- |
| `terraform init` | プロバイダー DLL の取得、バックエンド初期化 |
| `terraform validate` | HCL 構文チェック |
| `terraform plan` | 変更点を差分表示（実行はしない） |
| `terraform apply` | 変更を実際に適用（`-auto-approve` で非対話化） |
| `terraform destroy` | 管理対象を削除 |
| `terraform fmt` | コードを HCL スタイルに自動整形 |
| `terraform taint` / `untaint` | リソースを再作成候補に指定／解除 |
| `terraform state` subcommands | state ファイルの詳細操作（mv, rm, list など） |

### Providers

- **クラウド・SaaS の API を抽象化** したプラグイン。例：`aws`, `azurerm`, `google`, `kubernetes`, `cloudflare` など。
- `required_providers` ブロックでバージョン管理。`terraform init` 時に自動ダウンロード。
- **マルチプロバイダー**：`alias` を指定し、複数アカウント／リージョンを同時に操作可能。

### State

- **desired state（HCL）** と **actual state（remote の実リソース）** の橋渡しをするメタデータ。
- `.tfstate` ファイルに JSON 形式で保存され、毎回差分比較して idempotent に適用。
- 機密情報も含むため、**アクセス制御** と **バージョン管理** が重要。

### Backends

- **state の保存場所とロック方法** を定義。デフォルトはローカルファイル。
- 代表例：`s3` (+ DynamoDB ロック), `azurerm`, `gcs`, `remote` (Terraform Cloud/Terraform Enterprise), `consul`, `http`。
- チーム開発では **リモートバックエンド** ＋ **ロック機構** が必須。

### Provisioners

- **リソース作成後・破棄前に OS 内部でコマンド実行**。
- 代表例：`remote-exec`, `local-exec`, `file`。
- **運用上の注意**：失敗で apply 全体が abort／再試行困難、idempotency 低下。構成管理ツール（Ansible など）へ委譲するのが推奨ベストプラクティス。

### Modules

- **再利用可能な論理単位** をカプセル化。VPC、EKS クラスターなどのベストプラクティスを部品化。
- `source` に Git / Registry / ローカルパスを指定。変数でカスタマイズし、`outputs` で外部へ値を公開。
- **公式 Terraform Registry** にコミュニティ・認定モジュールが多数公開。
- **階層構造** をとれるため、大規模環境では “root module” + “child modules” として整理すると可読性とメンテ性が向上。

## TerraformとAnsible、CHEFの区別

### 目的と得意領域

| ツール | 何を自動化するか | 主な対象 | 典型的なユースケース |
| --- | --- | --- | --- |
| **Terraform** | インフラの作成・破棄（IaC ＝ Infrastructure as Code） | パブリック／プライベートクラウド、SaaS、ネットワーク | VPC・サブネット・ロードバランサ―の新規構築、マルチクラウド環境のブループリント作成 ([HashiCorp Developer](https://developer.hashicorp.com/terraform/intro/vs/chef-puppet?utm_source=chatgpt.com)) |
| **Ansible** | サーバー／ネットワーク機器の構成変更・アプリ導入・運用タスク | OS 設定、パッケージ、サービス、ユーザー、ACL など | OS Harden、Nginx などのアプリインストール、ローリングアップデート  |
| **Chef (Chef Infra)** | 複雑・大規模な構成管理をポリシーベースで継続適用 | サーバー群（オンプレ・クラウド） | 数千台規模のノードを一貫して構成し続ける、ポリシーガバナンス |

### アーキテクチャと実行モデル

| 観点 | Terraform | Ansible | Chef |
| --- | --- | --- | --- |
| **宣言／命令** | 完全宣言的（HCL） | YAML で宣言的だが逐次実行手順を記述 | Ruby DSL 宣言的（レシピ／リソース） |
| **ステート保持** | *tfstate* をローカルまたはリモートで保持し「理想状態」を追跡 | ステートを持たず都度ホストに対し idempotent 実行 | Chef Server が望ましい状態を保持、各ノードが Pull |
| **接続方式** | API 呼び出しのみ（エージェント不要） | SSH／WinRM（完全エージェントレス） | エージェント（chef-client）常駐 |
| **プッシュ／プル** | プッシュ（CLI からプロバイダー API へ） | プッシュ（制御端から対象へ） | プル（ノードが定期的にサーバーへ） |
| **不変／可変** | 不変インフラ志向（リソース差分を計算し置換） | 可変インフラ＆運用タスクを柔軟に実行 | 可変インフラだがポリシーで継続ドリフト修正 |

### 選択の指針

- **まず基盤を作るなら Terraform**
    - 新規 VPC、EKS クラスタ、RDS など「まだ存在しないリソース」を宣言的に構築。
    - 状態ファイルにより差分適用が明確。
- **できあがったサーバーを設定・更新するなら Ansible**
    - OS チューニング、アプリ導入、証明書更新など細かな運用フローをエージェントレスで即時プッシュ。
- **数百～数千台を長期にわたり一貫運用するなら Chef**
    - ポリシーを Chef Server で集中管理し、ノードが定期的に自己修復。
    - 依存解決や複雑なクックブック（Ruby DSL）で高度カスタムが可能。
- **組み合わせパターンが実践的**
    - Terraform で VM や Kubernetes ノードを作成 → Ansible で初期設定 → Chef または Ansible Tower/AWX で継続運用、という「レイヤ分け」が現場でよく採用されます。