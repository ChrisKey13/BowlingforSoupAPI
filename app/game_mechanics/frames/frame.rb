class Frame
  attr_reader :rolls, :next_rolls
  
  def initialize(rolls, next_rolls)
    @rolls = rolls
    @next_rolls = next_rolls
  end

  def self.create(rolls, next_rolls)
    new(rolls, next_rolls)
  end
  
  def score
    base_score + bonus_score
  end

  protected

  def base_score
    rolls.sum
  end

  def bonus_score
    raise NotImplementedError, 'Subclasses my implement the bonus_score method'
  end
end
  