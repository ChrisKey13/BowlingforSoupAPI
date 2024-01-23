class GameScorer
  def initialize(game)
    @game = game
    @next_roll_service = NextRollDeterminationService.new(game)
  end

  def calculate_total_score
    @game.total_score = @game.frames.each_with_index.sum do |frame, index|
      frame_score(frame, index)
    end
    @game.save
  end

  private

  def frame_score(frame, index)
    next_rolls = @next_roll_service.next_rolls_for_frame(index)
    FrameFactory.create(frame, next_rolls).score
  end
end
