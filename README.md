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
### ⑧viewの追加
#### ①_index.html.erbに追加
```
        <td><%= "フォロー数: #{user.follower.count}" %></td>
        <td><%= "フォロワー数: #{user.followed.count}" %></td>
        <td>
          <% unless user == current_user %>
            <% if current_user.following?(user) %>
              <%= link_to 'フォロー外す', unfollow_path(user.id), method: :POST %>
            <% else %>
              <%= link_to 'フォローする', follow_path(user.id), method: :POST %>
            <% end %>
          <% end %>
        </td>
```
#### ②_info.html.erbに追加
```
  <tr>
	  <th>follows</th>
	  <th><%= link_to "#{user.follower.count}", user_follows_path(user.id) %></th>
  </tr>
  <tr>
	  <th>followers</th>
	  <th><%= link_to "#{user.followed.count}", user_followers_path(user.id) %></th>
  </tr>
  <% unless user == current_user %>
    <tr>
      <% if current_user.following?(user) %>
        <th><%= link_to 'フォロー外す', unfollow_path(user.id), class: "btn btn-sm btn-warning", method: :POST %></th>
      <% else %>
        <th><%= link_to 'フォローする', follow_path(user.id), class: "btn btn-sm btn-primary", method: :POST %></th>
      <% end %>
    </tr>
  <% end %>
```