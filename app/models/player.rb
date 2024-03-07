class Player < ApplicationRecord
    belongs_to :game_session
    has_many :games, dependent: :destroy
  
    validates :name, presence: true

    after_create :create_initial_game

    private

    def create_initial_game
        puts "Creating initial game for Player #{id}"
        game = games.create(total_score: 0, game_session_id: self.game_session_id)
        if game.persisted?
          puts "Initial game created successfully: #{game.inspect}"
        else
          puts "Failed to create initial game: #{game.errors.full_messages}"
        end
    end
end