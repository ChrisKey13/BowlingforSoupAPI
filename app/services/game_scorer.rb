class GameScorer
  def initialize(game)
    @game = game
  end

  def calculate
    total_score = 0
    rolls = @game.rolls.to_a

    frame_index = 0
    10.times do
      frame_rolls = rolls[frame_index, 2]
      next_rolls = rolls[frame_index + 2, 2]

      if frame_rolls.nil? || frame_rolls.empty?
        break
      end
      
      frame = FrameFactory.create(frame_rolls, next_rolls)

      total_score += frame.score
      frame_index += frame_rolls[0] == 10 ? 1 : 2
    end

    total_score
  end
end
