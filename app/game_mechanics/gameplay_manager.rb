class GameplayManager
  
  def initialize(game)
    @game = game
  end

  def add_roll(pins)
    RollService.new(@game).add_roll(pins)
    GameScorer.new(@game).calculate_total_score
  end

end


