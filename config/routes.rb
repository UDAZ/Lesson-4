Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  resources :users,only: [:show,:index,:edit,:update] do
    get 'follows' => 'users#follows', as: 'follows'    #フォロー一覧
    get 'followers' => 'users#followers', as: 'followers'    #フォロワー一覧
  end
  resources :books
  get 'home/about' => 'homes#about'
  post 'follow/:id' => 'relationships#follow', as: 'follow' # フォロー
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' # フォロー解除
end