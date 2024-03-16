class GameSession < ApplicationRecord
    has_many :players, dependent: :destroy
    has_many :games, through: :players
    has_many :participations
    has_many :teams, through: :participations

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

    def winning_teams
        highest_total_score = teams.joins(players: :games)
                                    .group('teams.id')
                                    .having('SUM(games.total_score) > 0')
                                    .sum('games.total_score')
                                    .values
                                    .max
        
        return Team.none unless highest_total_score
      
        teams.joins(players: :games)
            .select('teams.*, SUM(games.total_score) AS total_team_score')
            .group('teams.id')
            .having('SUM(games.total_score) = ?', highest_total_score)
    end
      
end
