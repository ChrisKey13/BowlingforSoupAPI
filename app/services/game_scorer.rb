class GameScorer
  def initialize(game_context)
    @game_context = game_context
    @next_roll_service = NextRollDeterminationService.new(game_context)
  end

  def calculate_total_score

    calculated_score = @game_context.frames.each_with_index.sum do |frame, index|
      frame_score(frame, index)
    end 

    ActiveRecord::Base.transaction do
      @game_context.update_total_score(calculated_score)
      @game_context.game.save!
    end
  end

  private

  def frame_score(frame, index)
    next_rolls = @next_roll_service.next_rolls_for_frame(index)
    FrameFactory.create(frame, next_rolls).score
  end
end
