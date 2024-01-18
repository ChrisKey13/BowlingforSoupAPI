class RegularFrameRollStrategy
    include RollStrategy
  
    def initialize(game)
        @game = game
        @roll_manager = GameplayManager.new(game)
    end
  
    def roll(pins)
        @roll_manager.add_roll(pins)
    end
end