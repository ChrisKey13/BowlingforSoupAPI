class Team < ApplicationRecord
    has_many :team_players, dependent: :destroy
    has_many :players, through: :team_players

    has_many :participations, dependent: :destroy
    has_many :game_sessions, through: :participations

    validates :name, presence: true, uniqueness: true
end
