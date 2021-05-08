Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  resources :users,only: [:show,:index,:edit,:update] do
    post 'follow/:id' => 'relationships#follow', as: 'follow' # フォローする
    post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' # フォロー外す
  end
  resources :books
  get 'home/about' => 'homes#about'

end