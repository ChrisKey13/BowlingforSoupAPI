class GameScorer
  def initialize(game)
    @game = game
  end

  def calculate_total_score
    total_score = 0
    @game.frames.each_with_index do |frame, index|
      next_rolls = determine_next_rolls(index)
      frame_score = score_for_individual_frame(frame, next_rolls)
      total_score += frame_score
    end
    @game.total_score = total_score
    @game.save
  end

  private

  def score_for_individual_frame(frame, next_rolls)
    frame_object = FrameFactory.create(frame, next_rolls)
    frame_object.score
  end

  def determine_next_rolls(index)
    if index < Game::FRAMES_PER_GAME - 1
      next_roll_index = @game.frames[0..index].map(&:length).sum
      all_rolls = @game.frames.flatten
      [all_rolls[next_roll_index], all_rolls[next_roll_index + 1]].compact
    else
      final_frame_rolls = @game.frames.last
      final_frame_rolls.length == 3 ? final_frame_rolls.last(2) : [final_frame_rolls[1]].compact
    end
  end
end
