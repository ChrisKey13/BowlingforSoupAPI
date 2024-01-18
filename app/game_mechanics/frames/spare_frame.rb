class SpareFrame < Frame
  
  def self.create(rolls, next_rolls)
    rolls.sum == Game::MAX_PINS && rolls.count == 2 ? new(rolls, next_rolls) : nil
  end
  
  def score
    Game::MAX_PINS + next_rolls[0].to_i
  end
end
  