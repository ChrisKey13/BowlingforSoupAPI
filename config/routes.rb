Rails.application.routes.draw do
  resources :games, only: [:create, :show] do
    member do
      patch 'roll'
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
