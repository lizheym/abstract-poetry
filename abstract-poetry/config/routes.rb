Rails.application.routes.draw do
  resources :poems do
    get "index"
    get "new"
    post "create"
    get "show"
    post "cycle_nouns"
    post "shuffle_nouns"
    post "cycle_adjectives"
    post "shuffle_adjectives"
    get "delete"
  end

  root 'poems#new'
end
