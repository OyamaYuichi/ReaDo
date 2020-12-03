Rails.application.routes.draw do
  root to: 'oauth_test#index'
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :books do
    resources :summaries, only: [:new, :create] do
    end
  end

  resources :summaries do
    collection do
      get :search
    end
  end
  # resources :books
end
