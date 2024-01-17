class FrameFactory
  def self.create(rolls, next_rolls)
    return NormalFrame.new(rolls, next_rolls) if rolls.nil? || rolls.empty?
    return StrikeFrame.new(rolls, next_rolls) if rolls[0] == Game::MAX_PINS
    return SpareFrame.new(rolls, next_rolls) if rolls.sum == Game::MAX_PINS

    NormalFrame.new(rolls, next_rolls)
  end
end