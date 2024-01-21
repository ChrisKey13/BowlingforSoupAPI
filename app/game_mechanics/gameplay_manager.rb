class GameplayManager
  include FrameCompleteness

  def initialize(game)
    @game = game
  end

  def add_roll(pins)
    puts "Adding roll: #{pins} to Frame: #{@game.current_frame}, Roll Number: #{@game.current_roll}"

    update_frames(pins)
    update_counts
    puts "After update_counts - Frame: #{@game.current_frame}, Roll: #{@game.current_roll}, Frames: #{@game.frames.inspect}"
    GameScorer.new(@game).calculate_total_score
  end

  private

  def update_frames(pins)
    if new_frame_needed?
      @game.frames << [pins]
    else
      @game.frames.last << pins
    end
    
  end
  

  def update_counts
    puts "Checking if new frame is needed. Current Frame: #{@game.current_frame}, Last Frame Rolls: #{@game.frames.last.inspect}"
    if new_frame_needed?
      advance_frame
    else
      increment_roll
    end
    puts "After update_counts - Frame: #{@game.current_frame}, Roll: #{@game.current_roll}, Frames: #{@game.frames.inspect}"

  end
  

  def advance_frame
    puts "Advancing from Frame: #{@game.current_frame} to Frame: #{@game.current_frame + 1}"
    @game.current_frame += 1
    @game.current_roll = 0
    puts "Advancing from Frame: #{@game.current_frame - 1} to Frame: #{@game.current_frame}"

  end
  

  def increment_roll
    @game.current_roll += 1
  end

  def new_frame_needed?
    puts "Checking if new frame is needed. Current Frame: #{@game.current_frame}, Last Frame Rolls: #{@game.frames.last.inspect}"

    need_new_frame = @game.frames.empty? || frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
    need_new_frame
  end
  

  def final_frame?
    @game.current_frame >= Game::FRAMES_PER_GAME
  end
end


