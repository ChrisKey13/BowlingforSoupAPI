class FinalFrameState < GameState
    def initialize(game)
      super(game)
      @roll_strategy = FinalFrameRollStrategy.new(game)
    end
  end
  