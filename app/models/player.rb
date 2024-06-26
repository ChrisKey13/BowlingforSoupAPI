class Player < ApplicationRecord
  include Searchable

    belongs_to :game_session
    has_many :games, dependent: :destroy
    has_many :team_players
    has_many :teams, through: :team_players
  
    validates :name, presence: true

    after_create :create_initial_game

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :name, type: 'text', analyzer: 'standard'
        indexes :name_suggest, type: 'completion', analyzer: 'simple', search_analyzer: 'simple'
      end
    end
  
    def as_indexed_json(options={})
      super.merge({
        model_type: self.class.name.downcase,
        game_session_id: game_session_id,
        games_count: games.count,
        teams_count: teams.count,
        name_suggest: {
          input: [name],
          weight: 5
        }
      })
    end
  

    private

    def create_initial_game
      game = games.create(total_score: 0, game_session_id: self.game_session_id)
    end
end