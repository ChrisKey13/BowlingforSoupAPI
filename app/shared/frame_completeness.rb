module FrameCompleteness
  def frame_complete?(game, frame_rolls, is_final_frame: false)
    return false if frame_rolls.nil? || frame_rolls.empty?
    completion_condition = if is_final_frame
                              frame_rolls.length == 3 || (frame_rolls.length == 2 && frame_rolls.sum < 10)
                            else
                              frame_rolls.first == 10 || frame_rolls.length == 2
                            end

    # Adjusted debug statement to use local variable `completion_condition`
    puts "DEBUG: Frame complete? - Frame Rolls=#{frame_rolls.inspect}, Is Final Frame=#{is_final_frame}, Complete=#{completion_condition}"

    completion_condition
  end

  private
  
  def regular_frame_complete?(frame_rolls)
    frame_rolls.count == 2 || frame_rolls.first == GameConstraints.instance.max_pins
  end
  
  def final_frame_complete?(game)
    frame_rolls = game.frames.last || []
    rolls_count = frame_rolls.count

    rolls_count == 3 || (rolls_count == 2 && !is_spare_or_strike?(frame_rolls))
  end

  def is_spare_or_strike?(rolls)
    rolls.first == GameConstraints.instance.max_pins || rolls.sum == GameConstraints.instance.max_pins
  end
end
  