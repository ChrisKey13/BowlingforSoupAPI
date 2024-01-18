class GameplayManager
    def initialize(game)
      @game = game
    end
  
    def add_roll(pins)
      update_frame_and_rolls(pins)
      GameScorer.new(@game).calculate
    end

    private

    def update_frame_and_rolls(pins)
      if new_frame_needed?
        @game.frames << [pins]
      else
        @game.frames.last << pins
      end
      update_frame_and_roll_count
    end

    def new_frame_needed?
      @game.frames.empty? || (regular_frame_complete? && @game.current_frame < Game::FRAMES_PER_GAME)
    end
    

    def update_frame_and_roll_count
      if new_frame_needed? && @game.current_frame < Game::FRAMES_PER_GAME
        @game.current_frame += 1
        @game.current_roll = 1
      else
        @game.current_roll += 1
      end
    end

    def regular_frame_complete?
      current_frame_rolls = @game.frames.last || []
      current_frame_rolls.count == 2 || current_frame_rolls.first == Game::MAX_PINS
    end
    

  end
  