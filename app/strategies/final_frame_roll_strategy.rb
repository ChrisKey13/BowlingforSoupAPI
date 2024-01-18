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
        if frame_complete?(@game, @game.frames.last, is_final_frame: true)
            @game.state = GameOverState.new(@game)
        end
    end  
end