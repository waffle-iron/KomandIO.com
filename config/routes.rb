Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  resources :github_repos

  get "/dashboard", to: "dashboard#show"

  root "github_repos#index"

  resources :git_repos do 
    resources :pull_requests
  end

  resources :rebases
end
