RSpec::Matchers.define :have_total_score do |expected|
  match do |game|
    game.total_score == expected
  end

  failure_message do |game|
    "expected that game would have total score of #{expected} but was #{game.total_score}"
  end
end
