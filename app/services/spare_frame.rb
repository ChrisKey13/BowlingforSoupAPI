class SpareFrame < Frame
    def score
      10 + @next_rolls[0].to_i
    end
end
  