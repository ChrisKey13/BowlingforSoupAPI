Rails.application.routes.draw do
  
  resources :game_sessions, only: [:create, :show] do
    member do
      get 'winner'
    end
    resources :games, only: [:create, :show] do
      member do
        patch 'roll'
      end
    end
    resources :players, only: [:index, :create]
  end

  resources :teams, only: [:create, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
