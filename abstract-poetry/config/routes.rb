Rails.application.routes.draw do
  resources :poems do
    get "index"
    get "new"
    post "create"
    get "show"
    post "cycle"
    get "delete"
  end

  root 'poems#new'
end
