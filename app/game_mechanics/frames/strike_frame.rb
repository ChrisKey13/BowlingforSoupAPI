class StrikeFrame < Frame
  def self.create(rolls, next_rolls)
    if rolls.first == GameConstraints.instance.max_pins
      new(rolls, next_rolls)
    else
      nil
    end
  end

  def score
    GameConstraints.instance.max_pins + next_rolls[0].to_i + next_rolls[1].to_i
  end
end
