class StrikeFrame < Frame
  
  def self.create(rolls, next_rolls)
    rolls.first == Game::MAX_PINS ? new(rolls, next_rolls) : nil
  end

  def score
    Game::MAX_PINS + next_rolls[0].to_i + next_rolls[1].to_i
  end
end
  