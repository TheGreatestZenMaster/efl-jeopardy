Rails.application.routes.draw do
    root "sessions#new"
    
    delete '/reset',  to: 'sessions#destroy'
    resources :games, only: [:show]
    resources :questions, only: [:show]
    resources :sessions, only: [:new, :create, :destroy]
end
