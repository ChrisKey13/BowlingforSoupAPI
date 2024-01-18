class FinalFrameRollStrategy
    include FrameCompleteness
    include RollStrategy
  
    def initialize(game)
        @game = game
        @roll_manager = GameplayManager.new(game)
    end
  
    def roll(pins)
        @roll_manager.add_roll(pins)
        transition_to_game_over_if_needed
    end

    private

    def transition_to_game_over_if_needed
        @game.state = GameOverState.new(@game) if final_frame_complete?(@game)
    end
end