class GameState
    attr_accessor :game, :roll_strategy
  
    def initialize(game)
        @game = game
        @roll_strategy = nil
    end
  
    def roll(pins)
        @roll_strategy.roll(pins) if @roll_strategy
    end
end
  