Rails.application.routes.draw do
  
  resources :game_sessions, only: [:create, :show] do
    resources :games, only: [:create, :show] do
      member do
        patch 'roll'
      end
    end

    resources :players, only: [:index, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
