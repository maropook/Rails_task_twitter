# Twitterもどき

## About

課題で作成しているrailsのプロジェクト

##　使い方
- git clone
- bundle install
- yarn install
- rails db:migrate
- rails s

# 目標
twitterもどきを作る

#どんな設計にするのか
・ユーザー
→投稿できる
→投稿に対してコメントを残すことができる

・投稿
→内容のみ

・コメント
→内容のみ

# プロジェクトの作成
```
$ rails new twitter
$ cd twitter
```

# 投稿機能を作る
## モデルの作成
今回は投稿者用のUserモデルと投稿用のPostモデルを作る

### deviseの導入
ログインができるようにdeviseを導入します。
Gemfileに以下を追加

```rb:Gemfile
gem 'devise'
```
deviseを使える環境を整えていきます。

```
$ bundle install
$ rails g devise:install
$ rails g devise user
$ rails g devise:views
```
### Postモデルの作成
投稿用のPostモデルを作成します。ここには投稿内容contentと、誰が投稿したのかというuser_idが入るようにします。

```
$ rails g model post content:string user:references
$ rails db:migrate
```
### アソシエーションの確認
今作ったUserモデルとPostモデルは<b>１対多</b>の関係です。
ユーザーそれぞれはたくさんの投稿ができ、投稿それぞれは1人のユーザーによって書かれたものであるというようなイメージです。

#### user.rb
```app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy
end
```
`has_many :posts` の後に今回はdependent: :destroyをつけました。これはpostがuserに依存している。ここでは、もしユーザーがデータベースから削除されてしまった場合にユーザーがした投稿も全て消えるようになります。

#### post.rb
モデルの作成時に`user:references`をつけたのですでに`belongs_to :user`が書かれています。

```app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
end
```
## コントローラーの作成
### users_controller
ユーザーの一覧ページと詳細ページがあることを考慮して、indexアクションとshowアクションを定義します。

```
$ rails g controller users index show
```

### posts_controller
投稿も同様にindexアクションとshowアクションを定義します。(createアクションもあるが、ビューが存在しないのでここでは書かない)

```
$ rails g controller posts index show
```
# ルーティングの作成
ルーティングを考えていきます。

・投稿の一覧と詳細が見れる
・投稿することができる
・ユーザーの一覧と詳細が見れる
ことから以下のようなルーティングにします。
####routes.rb
```config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create]

  root 'posts#index'

end
```
# コントローラーのアクションの作成

## posts_controller.rb
posts_controllerを以下のように変更しよう。

```app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  def index
    @posts = Post.all
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end
```
ログインしていないユーザーはshow, createは実行できないようになりました。
# アクションに対応するビューの作成
次はビューを作っていきます。
#### posts/index.html.erb
```erb:app/views/posts/index.html.erb
<h1>コメントサンプル</h1>
<% if user_signed_in? %>
  <%= link_to "ログアウト", destroy_user_session_path, :method => :delete %>
  <%= link_to "マイページへ", user_path(current_user.id) %>
  <h2>投稿する</h2>
  <%= form_for @post do |f| %>
    <%= f.text_field :content %>
    <%= f.submit %>
  <% end %>
  <hr>
  <h2>投稿一覧</h2>
  <% @posts.each do |post| %>
    <a href="/users/<%= post.user.id %>"><%= post.user.email %></a>
    <p><a href="/posts/<%= post.id %>"><%= post.content %></a></p>
  <% end %>

<% else %>
  <%= link_to "ユーザー登録", new_user_registration_path %>
  <%= link_to "ログイン", new_user_session_path %>
<% end %>
```
#### posts/show.html.erb
```erb:app/views/posts/show.html.erb
<h1>投稿詳細ページ</h1>
<h3><%= @post.user.email %></h3>
<h3><%= @post.content %></h3>
<%= link_to "ホームへ戻る", posts_path %>
```
#### users_controller.rb
```app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
```
#### users/index.html.erb
```erb:app/views/users/index.html.erb
<h1>ユーザー一覧</h1>
<% @users.each do |user| %>
  <a href="/users/<%= user.id %>"><%= user.email %></a>
  <hr>
<% end %>
<%= link_to "ホームへ戻る", posts_path %>
```
#### users/show.html.erb
```erb:app/views/users/show.html.erb
<h1>ユーザー詳細ページ</h1>
<h3><%= @user.email %></h3>
<h2>投稿内容</h2>
<% @user.posts.each do |post| %>
  <a href="/posts/<%= post.id %>"><%= post.content %></a>
  <hr>
<% end %>
<%= link_to "ユーザー一覧へ", users_path %>
<%= link_to "ホームへ戻る", posts_path %>
```

# Commentモデルをつくろう
これからやっとコメント機能を実装していきます。
コメント機能は、誰がどの投稿に対してコメントをしたのかという情報をCommentテーブルというUserテーブルとPostテーブルの中間テーブルに格納していきます。

```
$ rails g model comment content:string user:references post:references
$ rails db:migrate
```
## アソシエーションの確認

#### user.rb
```app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments
end
```
#### post.rb
```app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
end
```

# コントローラーの作成
#### comments_controller
```
$ rails g controller comments
```
# ルーティングの作成
#### routes.rb
```config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create] do
    resources :comments, only: [:create]
  end

  root 'posts#index'
end
```
# コントローラーのアクションの作成
#### comments_controller.rb
```app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end

  end
  
  private
  def comment_params
    params.require(:comment).permit(:content, :post_id) #追加
  end
end

```
#### posts_controller.rb
```app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  def index
    @posts = Post.all
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end

```
# アクションに対応するビューの変更
#### posts/show.html.erb
その投稿に対するコメントの一覧と、コメントができるようになります

```erb:app/views/posts/show.html.erb
<h1>投稿詳細ページ</h1>
<h3><%= @post.user.email %></h3>
<h3><%= @post.content %></h3>

<h2>コメント一覧</h2>
<% @comments.each do |c| %>
  <div>
    <a href="/users/<%= @post.user.id %>"><%= c.user.email %></a>
    <%= c.content %>
    <hr>
  </div>
<% end %>

<%= form_for [@post, @comment] do |f| %>
  <%= f.text_field :content %>
  <%= f.hidden_field :post_id, value: @post.id %> #追加
  <br>
  <%= f.submit 'コメントする', class: "btn btn-primary" %>
<% end %>

<%= link_to "ホームへ戻る", root_path %>

<%= link_to "ホームへ戻る", posts_path %>
```
# 以上です
これでユーザーが投稿に対してコメントができる
