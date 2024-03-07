RSpec::Matchers.define :be_a_spare do
    match do |game|
      frame = game.frames.last
      frame.sum == 10 && frame.first != 10
    end
  
    failure_message do |game|
      "expected the last frame of the game to be a spare"
    end
end
  