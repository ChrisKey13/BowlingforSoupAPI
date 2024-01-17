class StrikeFrame < Frame
    def score
      10 + @next_rolls[0].to_i + @next_rolls[1].to_i
    end
end
  