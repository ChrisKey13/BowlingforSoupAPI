class RegularFrameState < GameState
    def initialize(game)
        super(game)
        @roll_strategy = RegularFrameRollStrategy.new(game)
    end
end