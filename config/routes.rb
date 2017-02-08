Rails.application.routes.draw do
    root "static_pages#about"
    
    delete '/reset',  to: 'games#destroy'
    resources :games, only: [:show, :new, :create, :destroy]
    resources :questions, only: [:show]
end
