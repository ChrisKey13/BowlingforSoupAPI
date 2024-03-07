RSpec::Matchers.define :be_a_strike do
    match do |game|
      game.frames.last.first == 10
    end
  
    failure_message do |game|
      "expected the last frame of the game to be a strike"
    end
end
  