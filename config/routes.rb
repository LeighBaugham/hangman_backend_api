Rails.application.routes.draw do
  resources :games
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "/login", to: "users#login"
  post "/score", to: "users#score"
  get "/leaders", to: "users#leaders"
end
