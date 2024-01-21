class GameOverState < GameState
    GAME_OVER_MESSAGE = "Game is already over".freeze
    
    def roll(pins)
        puts GAME_OVER_MESSAGE
    end
end
  