Rails.application.routes.draw do
  # root to: 'oauth_test#index'
  root to: 'summaries#index'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  resources :books do
    resources :summaries, :memos, only: [:new, :create]
    resources :reviews
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
  resources :comment_favorites, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  # mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
