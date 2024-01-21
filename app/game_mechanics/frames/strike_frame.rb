class StrikeFrame < Frame
  
  def self.create(rolls, next_rolls)
    if rolls.first == Game::MAX_PINS
      new(rolls, next_rolls)
    else
      nil
    end
  end

  def score
    puts "Calculating #{self.class.name} score: Base Rolls - #{rolls.inspect}, Next Rolls - #{next_rolls.inspect}"

    Game::MAX_PINS + next_rolls[0].to_i + next_rolls[1].to_i
  end
end
