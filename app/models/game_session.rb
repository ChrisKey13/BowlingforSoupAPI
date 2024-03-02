class GameSession < ApplicationRecord
    has_many :players, dependent: :destroy
    has_many :games, through: :players

    accepts_nested_attributes_for :players

    def winner
        games.order(total_score: :desc).first.player
    end
end
