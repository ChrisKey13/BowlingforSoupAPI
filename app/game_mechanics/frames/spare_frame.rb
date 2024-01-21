class SpareFrame < Frame
  
  def self.create(rolls, next_rolls)
    if rolls.sum == GameConstraints.instance.max_pins && rolls.count == 2
      new(rolls, next_rolls)
    else
      nil
    end
  end
  
  def score
    GameConstraints.instance.max_pins + next_rolls[0].to_i
  end  
end
