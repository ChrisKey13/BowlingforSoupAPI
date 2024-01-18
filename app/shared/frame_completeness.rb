module FrameCompleteness
  def frame_complete?(game, frame_rolls, is_final_frame: false)
    return false if frame_rolls.nil? || frame_rolls.empty?
    
    if is_final_frame
      final_frame_complete?(game)
    else
      regular_frame_complete?(frame_rolls)
    end
  end

  private
  
  def regular_frame_complete?(frame_rolls)
    frame_rolls.count == 2 || frame_rolls.first == Game::MAX_PINS
  end
  
  def final_frame_complete?(game)
    frame_rolls = game.frames.last || []
    rolls_count = frame_rolls.count

    rolls_count == 3 || (rolls_count == 2 && !is_spare_or_strike?(frame_rolls))
  end

  def is_spare_or_strike?(rolls)
    rolls.first == Game::MAX_PINS || rolls.sum == Game::MAX_PINS
  end
end
  