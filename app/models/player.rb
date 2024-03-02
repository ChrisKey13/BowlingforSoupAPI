class Player < ApplicationRecord
    belongs_to :game_session
    has_many :game, dependent: :destroy
  
    validates :name, presence: true
  end
  