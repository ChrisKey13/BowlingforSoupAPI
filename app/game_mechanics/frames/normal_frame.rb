class NormalFrame < Frame
  def score
    puts "Calculating #{self.class.name} score: Base Rolls - #{rolls.inspect}, Next Rolls - #{next_rolls.inspect}"
    rolls.sum
  end
  
end
  