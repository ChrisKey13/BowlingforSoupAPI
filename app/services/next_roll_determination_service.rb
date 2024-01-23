class NextRollDeterminationService
    def initialize(game)
        @game = game
    end

    def next_rolls_for_frame(index)
        regular_frame?(index) ? regular_frame_next_rolls(index) : final_frame_next_rolls
    end

    private

    def regular_frame?(index)
        index < GameConstraints.instance.frames_per_game - 1
    end

    def regular_frame_next_rolls(index)
        all_rolls = @game.rolls
        next_roll_index = next_roll_index_for(index)
        all_rolls[next_roll_index, GameConstraints.instance.regular_max_rolls].compact
    end

    def next_roll_index_for(index)
        @game.frames[0..index].sum(&:length)      
    end

    def final_frame_next_rolls
        final_frame_rolls = @game.frames[(GameConstraints.instance.frames_per_game - 1)]
        final_frame_rolls.length == GameConstraints.instance.final_max_rolls ? final_frame_rolls.last(GameConstraints.instance.regular_max_rolls) : [final_frame_rolls[1]].compact
    end
end