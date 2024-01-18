class GameplayManager
  include FrameCompleteness

  def initialize(game)
    @game = game
  end
  
  def add_roll(pins)
    update_frames_with_rolls(pins)
    update_roll_and_frame_counts
    GameScorer.new(@game).calculate
  end

  private

  def update_frames_with_rolls(pins)
    if new_frame_needed?
      @game.frames << [pins]
    else
      @game.frames.last << pins
    end  
  end

  def update_roll_and_frame_counts
    if new_frame_needed?
      @game.current_frame += 1
      @game.current_roll = 1
    else
      @game.current_roll += 1
    end
  end

  def new_frame_needed?
    @game.frames.empty? || (frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?) && !final_frame?)
  end

  def final_frame?
    @game.current_frame >= Game::FRAMES_PER_GAME
  end

end
  