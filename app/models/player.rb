class Player < ApplicationRecord
    belongs_to :game_session
    has_many :games, dependent: :destroy
    has_many :team_players
    has_many :teams, through: :team_players
  
    validates :name, presence: true

    after_create :create_initial_game

    private

    def create_initial_game
      game = games.create(total_score: 0, game_session_id: self.game_session_id)
    end
end