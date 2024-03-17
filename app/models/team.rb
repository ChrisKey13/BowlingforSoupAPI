class Team < ApplicationRecord
    include Searchable
  
    has_many :team_players, dependent: :destroy
    has_many :players, through: :team_players
  
    has_many :participations, dependent: :destroy
    has_many :game_sessions, through: :participations
  
    validates :name, presence: true, uniqueness: true
  
    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :name, type: 'text', analyzer: 'standard'
        indexes :name_suggest, type: 'completion', analyzer: 'simple', search_analyzer: 'simple'
      end
    end
  
    def as_indexed_json(options={})
      super.merge({
        model_type: self.class.name.downcase,
        players_count: team_players.count,
        participations_count: participations.count,
        game_sessions_count: game_sessions.count,
        name_suggest: {
          input: [name],
          weight: 10
        }
      })
    end
  end
  