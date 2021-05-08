# Lesson-4 フォローとフォロワー機能

### ①relationshipモデル作成
```
rails g model relationship follower_id:integer followed_id:integer
```
### ②モデルに関連付け
#### ①userモデルに関連付け
```
has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
```
#### ②relationshipモデルに関連付け
```
belongs_to :follower, class_name: "User"
belongs_to :followed, class_name: "User"
```
#### ③throughを使ったuserモデルに関連付け
```
has_many :following_user, through: :follower, source: :followed #自分がフォローしている人
has_many :follower_user, through: :followed, source: :follower #自分をフォローしている人
```
### ④userモデルにメソッド作成
```
# ユーザーをフォローする
def follow(user_id)
  follower.create(followed_id: user_id)
end

# ユーザーのフォローを外す
def unfollow(user_id)
  follower.find_by(followed_id: user_id).destroy
end

# フォローしていればtrueを返す
def following?(user)
  following_user.include?(user)
end
```
### ⑤relationshipsコントローラーを作成
```
rails g controller relationships
```
### ⑥relationshipsコントローラーに追記
```
def follow
  current_user.follow(params[:id])
  redirect_to root_path
end

def unfollow
  current_user.unfollow(params[:id])
  redirect_to root_path
end
```
### ⑦ルーティングを追加
```
post 'follow/:id' => 'relationships#follow', as: 'follow' # フォローする
post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' # フォロー外す
```