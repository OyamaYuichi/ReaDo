Rails.application.routes.draw do
  root to: 'oauth_test#index'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :books do
    resources :summaries, :memos, only: [:new, :create]
  end

  resources :summaries do
    resources :comments
  end

  resources :memos, only: [:index, :edit, :show, :update, :destroy]

  resources :users, only: [:index, :show] do
    collection do
      get :following, :follower
    end
  end
  resources :favorites, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
