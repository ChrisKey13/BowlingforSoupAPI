class GameScorer
  def initialize(game)
    @game = game
  end

  def calculate
    total_score = 0
    @game.frames.each_with_index do |frame, index|
      total_score += score_for_frame(frame, index)
    end
    total_score
  end

  private

  def score_for_frame(frame, index)
    current_frames_rolls = frame

    next_rolls = @game.frames[index + 1, 2].flatten

    frame_object = FrameFactory.create(current_frames_rolls, next_rolls)
    
    frame_object.score
  end
end
