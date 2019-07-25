Rails.application.routes.draw do
  get 'search', to: 'search_tweets#index'

  root  "search_tweets#index"
end
