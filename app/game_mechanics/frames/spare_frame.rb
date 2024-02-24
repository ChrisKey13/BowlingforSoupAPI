class SpareFrame < Frame

  def self.valid?(rolls, next_rolls)
    rolls.sum == GameConstraints.instance.max_pins && rolls.count == 2
  end
  
  def bonus_score
    next_rolls.first.to_i
  end  
end
