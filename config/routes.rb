Rails.application.routes.draw do
  devise_for :users
  resources :books
  resources :users, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "books#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
