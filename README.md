# terraformでIAMのコンソールアクセス可能なユーザーを作る

ちょっといろいろ考慮ポイントが多そうなので割愛

terraform で作ってconsoleで実行していくとする

https://stackoverflow.com/questions/36565256/set-the-aws-console-password-for-iam-user-with-terraform

# 追加の構築のポイント

- db部分
    - ローカル環境でdbとの接続をテストするためにコンテナでmysqlを用意する方針とする
        - コンテナでいつでも同様のmysqlコンテナ作成ができるようにdocker-compose.ymlに環境変数でdbの必要項目を明記の上いつでも立ち上げ可能な状態にしておく
    - rdsもterraformで作成する
        - 作成時に削除時のsnapshot作成requireをskipすること
        - 各rdsの認証情報はvariables.tfと.tfvarsファイルにて管理
        - APIアプリケーションが使うための認証情報の渡し方は、userdataの中に埋め込みterraform変数を使って.envファイルを作る。
        - 新たなプライベートサブネットとセキュリティグループを作成する。
            - セキュリティグループはingressの送信元としてapiのセキュリティグループを指定する試みをする
- webサーバー
    - nginx:変更特段なし
    - html:新たにfetchでdbから受け取った情報を表示するためのボタンを作成する。
    - css:特段変更無し
    - javascript:fetchのコードを作成し/dbapiから受け取ったコードを表示するための構文を作成。
        - 複数の値の処理に対応するため、jsonで受け取ったdataの値はArray(配列)として適切な内容かを判定している
        - 渡される形は[{id:1, name: "Alice"}, {id:2, name: "yamamoto"}]みたいなものになるから
            
            この場合はokとなる。違えばエラーとなる
            
        - 各オブジェクトのnameの部分を取得してカンマ区切りの文字列に変換して表示窓に表示する。
        
        mapで処理されて、["Alice", "yamamoto"]が渡され、.joinで,区切りで配列の要素を連結して文字列化する
        
- apiサーバー
    - /dbapiを受け取った場合のハンドラーを定義
    - ハンドラーの処理としてrepositoriesで定義したクエリ用のコードの呼び出しを宣言する
    - ハンドラーが期待する値は、models構造体で定義した値となる
    - 期待する値はjsonエンコードされて出力がされる
    - repositoriesではdbの接続、db接続の判定、dbへのselect * from テーブルのクエリ実行、クエリ結果をmodelsで定義した構造体への格納、ハンドラーへの渡しまでを担当
    - .envファイルをローカルでもgithubから落としたソースコードでも使えるようにしたい。
        
        ってので、godotenvライブラリを使用。これによりOSの環境変数よりも前に.envファイルを指定の場所から探してそれで環境変数を使ってくれる
        
- iam
    - ポリシー
        - 4つのユーザーアカウントに対するrds,ec2,iamに対する処理について
            - 最小権限の原則に従い
                - describe系はフルリソースとした
                - create ,modify, delete系は各リソースごとに定義した
                - instance以外にsnapshotの作成リストアも許可を見直した
    - ユーザープロファイル(マネジメントコンソールログインについて)
        - keybaseというpgp(**"Pretty Good Privacy"** )を管理するプラットフォームとterraformで連動できることを知ったので
        - pgpをkeybaseで作成しterraformでそこから取得して、awsのマネコン用の初期パスワードとして設定をした。
