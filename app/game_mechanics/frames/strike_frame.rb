class StrikeFrame < Frame
  
  def self.valid?(rolls, next_rolls)
    rolls.first == GameConstraints.instance.max_pins
  end

  def score
    GameConstraints.instance.max_pins + next_rolls[0].to_i + next_rolls[1].to_i
  end
end
