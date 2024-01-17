class FrameFactory
    def self.create(rolls, next_rolls)
      return NormalFrame.new([], []) if rolls.nil? || rolls.empty?
  
      if rolls[0] == 10
        StrikeFrame.new(rolls, next_rolls)
      elsif rolls.sum == 10
        SpareFrame.new(rolls, next_rolls)
      else
        NormalFrame.new(rolls, next_rolls)
      end
    end
end
  