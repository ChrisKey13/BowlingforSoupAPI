class GameSession < ApplicationRecord
    has_many :players, dependent: :destroy
    has_many :games, through: :players

    accepts_nested_attributes_for :players

    def winner
        scored_games = games.where.not(total_score: nil)
        winning_game = scored_games.order(total_score: :desc).first
        winning_game&.player
    end

    def winners
        winning_score = games.maximum(:total_score)
        tied_winners = games.where(total_score: winning_score).map(&:player)
    end

end
