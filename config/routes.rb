Rails.application.routes.draw do
  devise_for :users
  resources :poems do
    get "index"
    get "new"
    post "create"
    get "show"
    get "my_poems", :on => :collection
    post "cycle_nouns"
    post "shuffle_nouns"
    post "cycle_adjectives"
    post "shuffle_adjectives"
    post "cycle_lines"
    post "shuffle_lines"
    get "about", :on => :collection
    get "delete"
  end

  root 'poems#index'
end
