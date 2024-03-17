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

  resources :teams do
    resources :team_players, only: [:create, :destroy] do
      collection do
        patch 'update_players', action: :update
      end
    end
  end

  resources :participations, only: [:create]

  get 'search', to: 'search#index'

  get "up" => "rails/health#show", as: :rails_health_check
end
