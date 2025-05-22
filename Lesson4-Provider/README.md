# Terraform Provider

Terraform は「宣言された状態」と「実際のクラウド／SaaS 環境」を同期させるツールですが、その**API 呼び出し部分を受け持つプラグイン**が **Provider**です。

- 1 つのProviderが **リソース型 (aws_instance など)** と **データソース型 (aws_ami など)** を実装します。
- `terraform plan / apply` 時に、Providerがクラウド API を呼び出して差分を実行します。

## 1. Providerの入手と初期化

| 手順 | 説明 |
| --- | --- |
| **required_providers** | `terraform` ブロックで「どのProviderを・どのバージョンで」使うか宣言。 |
| **terraform init** | 上記宣言を読み取り、必要なバイナリを ① Terraform Registry (registry.terraform.io)  ② プライベートレジストリ  ③ ローカルディレクトリ から取得して `.terraform/providers` へ配置。 |
| **lock ファイル** | 取得結果を `.terraform.lock.hcl` に固定。チームで同一バージョンを共有可能。 |

## 2. Provider設定ブロック

```hcl
provider "aws" {
  region  = "ap-northeast-1"
  profile = "production"
  default_tags {
    tags = {
      Project = "terraform-training"
    }
  }
}
```

- **認証情報**: 明示 (`access_key`, `secret_key`) も可能だが、**環境変数 / AWS CLI プロファイル / IAM ロール** を推奨。
- **default_tags** や **assume_role** など、特定Provider固有の拡張属性がある。
- バージョンは `required_providers` で指定し、**provider ブロックでは指定しない**のが慣例。

### エイリアス (alias)

同一Providerを別アカウント・別リージョンで併用する場合:

```hcl
provider "aws" {
  alias   = "tokyo"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "oregon"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "logs" {
  provider = aws.oregon
  bucket   = "my-logs-usw2"
}
```

**モジュール側で alias を使うとき** は、呼び出し側 (root) がを渡す必要があります (`module` 側は `terraform { required_providers { aws = { configuration_aliases = [ aws.tokyo ] } } }` を宣言)。

```hcl
module "vpc" {
  source  = "./modules/vpc"
  providers = {
    aws = aws.tokyo   # モジュールが期待する alias にマッピング
  }
}
```

## 3. Providerのライフサイクル

| フェーズ | 具体的な CLI | 説明 |
| --- | --- | --- |
| **Install** | `terraform init` | バイナリを取得・検証 (SHA-256 チェック)。 |
| **Configure** | `provider` ブロック解決 | 変数や alias を適用、不要時は再読み込み。 |
| **Plan / Refresh** | `terraform plan` | 現在状態を取得し差分を計算 (`read` API)。 |
| **Apply** | `terraform apply` | 作成・変更・削除を実行 (`create/update/delete` API)。 |
| **Import v2** | `terraform import` (v1.8～) | Provider側が Import スキーマを提供すると自動的に属性をマッピング。 |
| **Schema Upgrade** | 自動 | Providerの新バージョンアップで State を適宜アップグレード。 |

Providerは Terraform の「実行エンジン」に相当し、**どの API に対して・どのバージョンで・どの資格情報で操作するか** を決定します。

- `required_providers` で**宣言的に依存**を記述し、
- `provider` ブロックで **環境ごとの設定** を与え、
- `.terraform.lock.hcl` で **チーム全体の再現性** を確保する
    
    これが Terraform におけるProvider管理の基本構造です。