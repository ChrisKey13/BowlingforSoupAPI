class Frame
    attr_reader :rolls, :next_rolls
  
    def initialize(rolls, next_rolls)
      @rolls = rolls
      @next_rolls = next_rolls
    end
  
    def score
      raise NotImplementedError, 'Subclasses must implement the score method'
    end
end
  