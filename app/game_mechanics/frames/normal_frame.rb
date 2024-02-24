class NormalFrame < Frame
  def score
    rolls.sum
  end

  def self.valid?(rolls, next_rolls)
    true
  end
end
  