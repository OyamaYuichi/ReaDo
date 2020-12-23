# README

## 読書管理アプリ ReaDo

### リンク
https://powerful-taiga-65863.herokuapp.com/
### 概要
書籍の要約を読むことで知識をインプットしたり、
要約を投稿して知識をアプトプットするアプリケーションです。
また要約の閲覧・投稿だけでなく、設定したアクションプランを通知することで、
読書で得られた知識を実生活の行動へと促します。

### コンセプト
知識のインプットとアウトプット

### バージョン
- Ruby 2.6.5
- Ruby on Rails 5.2.4
- PostgreSQL 13.0

### 機能一覧
- ログイン機能
- 要約一覧表示機能
- 要約投稿機能
- 要約編集機能
- お気に入り機能
- 投稿検索機能
- ユーザープロフィール表示機能
- ユーザープロフィール編集機能
- メモ一覧表示機能
- メモ投稿機能
- メモ編集機能
- 書籍一覧表示機能
- 書籍投稿機能
- 書籍編集機能
- 書籍購入機能
- タグ機能
- コメント機能
- アクションプランお知らせ機能

### カタログ設計
https://docs.google.com/spreadsheets/d/1YHz_ReqRRiYHAoNYb_PMaS97YdOQNdm0OJqLgqtE2QA/edit?usp=sharing

### テーブル定義
https://docs.google.com/spreadsheets/d/1IfBsW56UoqpWtxLTfX3FY4eYO7BIGpDrxTDW2_kfUHk/edit?usp=sharing

### 画面遷移図
https://docs.google.com/spreadsheets/d/1r_bp8tvjIs5bM80v8Xb1Z-lrI7J9sGSULXOiiYbxquI/edit?usp=sharing

### ワイヤーフレーム
https://docs.google.com/spreadsheets/d/1w4HLXDFA7pTI2Phagpl5Zo66wMWw5V6S1hU6T7egYnc/edit?usp=sharing

### 使用gem
- carrierwave
- mini_magick
- devise
- ransack
- kaminari
- actiontext
- image_processing
- webpacker
- omniauth
- omniauth-google-oauth2
- omniauth-facebook
- omniauth-twitter
- devise-i18n
- enum_help
- font-awesome-rails
- font-awesome-sass
- rakuten_web_service
- google-api-client