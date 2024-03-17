class Team < ApplicationRecord
    include Searchable

    has_many :team_players, dependent: :destroy
    has_many :players, through: :team_players

    has_many :participations, dependent: :destroy
    has_many :game_sessions, through: :participations

    validates :name, presence: true, uniqueness: true

    def as_indexed_json(options={})
        super.merge({
            model_type: self.class.name.downcase,
            players_count: team_players.count,
            participations_count: participations.count,
            game_sessions_count: game_sessions.count
        })
    end
end
