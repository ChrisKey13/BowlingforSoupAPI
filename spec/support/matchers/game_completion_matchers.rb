RSpec::Matchers.define :be_finished_game do
    match do |game|
      game.frames.size == 10 && 
      (game.frames.last.size == 3 || 
      (game.frames.last.size == 2 && !spare_or_strike?(game.frames.last)))
    end
  
    failure_message do |game|
      "expected that the game would be finished"
    end
  
    def spare_or_strike?(frame)
      frame.sum == 10
    end
end
  