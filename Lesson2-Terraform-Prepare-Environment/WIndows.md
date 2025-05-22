# Windows

Windowsの場合、WSL2の利用が推奨です。

WSL2は、Windows 上でネイティブに近い Linux 環境を動かすための “第 2 世代” サブシステムです。Windows 10（1903 以降）と Windows 11 に標準搭載され、`wsl --install` だけで Ubuntu などのディストリビューションを数分で導入できます。([Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/about?utm_source=chatgpt.com))

WSL2を利用すると、ソフトウェアのインストールとバージョン管理が簡単になって、Windowsより開発しやすいというメリットがあります。

## **1.WSL2 のインストール**

1. Windows PowerShell を検索し，右クリックして「管理者として実行」を選択※ 『最新のPowerShellをインストールしてください』と勧めてくるが無視
    
    ![](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3471691%2F09fe0e59-c87b-2e34-8c09-65868591fb63.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=3900fc1fbe01c4679f42edb659a4beb7)
    
2. `wsl --install` と入力して，インストール開始 (所要時間:約20秒)
3. インストールが完了したら，再起動
    
    ![](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3471691%2F40711480-c057-9ce7-80ea-d865423f6759.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f26282e66c1405019eb35ff015ba79c6)
    
4. 再起動すると，ユーザー名を設定する画面が開く画面が開かなければ，検索バーから「Ubuntu」を検索
    
    ![](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3471691%2Fc2a8cd76-83da-f55e-e7e3-ad596e876077.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=865e48a70d10a41a60a345f8140dd953)
    
5. ユーザー名とパスワードを設定したら，WSL2 が使えるようになる
    
    ![](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F3471691%2Ffe65fdd4-ad22-9fa7-5f55-a081815fa6a9.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=c4dfa0807782496d5580f5829578560f)
    

---

## **2.Terraformのインストール（WSL2）**

以下のコマンドを入力して、Terraformのインストールを実施します。

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform

```

## **3.Terraformのインストール（Windows10/11）**

1. 公式ページからTerraformのZIPファイルをダウンロードします。
    
    [https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
    
2. 解凍して配置します。
3. 環境変数**PATH**にそのディレクトリを追加します。
    
    **PATH追加の参考：**[https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows)