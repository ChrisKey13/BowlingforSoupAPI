class SpareFrame < Frame

  def self.valid?(rolls, next_rolls)
    rolls.sum == GameConstraints.instance.max_pins && rolls.count == GameConstraints.instance.regular_max_rolls
  end
  
  def bonus_score
    next_rolls.first.to_i
  end  
end
