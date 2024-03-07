RSpec::Matchers.define :be_in_frame do |expected_frame|
    match do |game|
      game.current_frame == expected_frame
    end
  
    failure_message do |game|
      "expected the game to be in frame #{expected_frame} but was in frame #{game.current_frame}"
    end
end
  