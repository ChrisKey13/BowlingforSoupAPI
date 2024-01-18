class GameScorer
  def initialize(game)
    @game = game
  end

  def calculate
    total_score = 0
    @game.frames.each_with_index do |frame, index|
      frame_score = score_for_frame(frame, index)
      total_score += frame_score
    end
    @game.total_score = total_score
    @game.save
  end

  private

  def score_for_frame(frame, index)
    next_rolls = next_rolls_for_scoring(index)
    frame_object = FrameFactory.create(frame, next_rolls)  
    score = frame_object.score
  end
  
  def next_rolls_for_scoring(index)
    rolls = @game.frames.flatten
    current_frame_start = rolls[0..index * 2].count
    rolls[current_frame_start..current_frame_start + 2] 
  end
  
end
