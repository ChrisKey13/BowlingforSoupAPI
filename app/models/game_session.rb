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
        puts "Calculated Winning Score: #{winning_score}"
        tied_winners = games.where(total_score: winning_score).map(&:player)
        puts "Tied Winners Count: #{tied_winners.size}"
        tied_winners.each_with_index { |w, index| puts "Winner #{index + 1}: Player ID: #{w.id}, Score: #{w.games.find_by(game_session_id: self.id)&.total_score}" }
        tied_winners
      end

end
