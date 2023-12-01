Rails.application.routes.draw do
  resources :reports do
    resources :comments, only: %i(create destroy)
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    resources :comments, only: %i(create destroy)
  end
  resources :users, only: %i(index show)
end
