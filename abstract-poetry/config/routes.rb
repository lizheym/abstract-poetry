Rails.application.routes.draw do
  resources :poems do
    get "new"
    post "create"
    get "show"
  end

  root 'poems#new'
end
