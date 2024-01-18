class GameplayManager
  include FrameCompleteness

  def initialize(game)
    @game = game
  end

  def add_roll(pins)
    update_frames(pins)
    update_counts
    GameScorer.new(@game).calculate
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
    if new_frame_needed?
      advance_frame
    else
      increment_roll
    end
  end

  def advance_frame
    @game.current_frame += 1
    @game.current_roll = 1
  end

  def increment_roll
    @game.current_roll += 1
  end

  def new_frame_needed?
    @game.frames.empty? || frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
  end

  def final_frame?
    @game.current_frame >= Game::FRAMES_PER_GAME
  end
end
