Rails.application.routes.draw do
  resources :games, only: [:create, :show] do
    member do
      patch 'roll'
    end
  end

  ressources :game_session, only [:create] do
    resources :players, only: [] do
      post 'start_game', to: 'games#create_for_player'
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end
