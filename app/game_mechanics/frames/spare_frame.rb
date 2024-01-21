class SpareFrame < Frame
  
  def self.create(rolls, next_rolls)
    if rolls.sum == Game::MAX_PINS && rolls.count == 2
      new(rolls, next_rolls)
    else
      nil
    end
  end
  
  def score
    Game::MAX_PINS + next_rolls[0].to_i
  end  
end
