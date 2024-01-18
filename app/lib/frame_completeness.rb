module FrameCompleteness
    def final_frame_complete?(game)
      frame_rolls = game.frames.last || []
      rolls_count = frame_rolls.count
      first_roll = frame_rolls.first
      second_roll = frame_rolls.length > 1 ? frame_rolls[1] : 0
  
      case rolls_count
      when 1
        false
      when 2
        !(first_roll == Game::MAX_PINS || first_roll + second_roll == Game::MAX_PINS)
      else
        true
      end
    end
  end
  