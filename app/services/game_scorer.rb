class GameScorer
  def initialize(game_context)
    @game_context = game_context
    @next_roll_service = NextRollDeterminationService.new(game_context)
  end

  def update_total_score
    calculated_score = calculate_score
    update_score(calculated_score)
  end

  private

  def frame_score(frame, index)
    next_rolls = @next_roll_service.next_rolls_for_frame(index)
    FrameFactory.create(frame, next_rolls).score
  end

  def calculate_score
    @game_context.frames.each_with_index.sum do |frame, index|
      frame_score(frame, index)
    end 
  end

  def update_score(score)
    ActiveRecord::Base.transaction do
      @game_context.update_total_score(score)
      @game_context.game.save!
    end
  end
end
