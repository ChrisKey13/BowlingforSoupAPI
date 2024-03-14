RSpec::Matchers.define :have_score_for do |team_name, expected_score|
    match do |actual_scores|
      actual_scores[team_name] == expected_score
    end
  
    description do
      "have a score of #{expected_score} for team '#{team_name}'"
    end
  
    failure_message do |actual_scores|
      "expected that scores for team '#{team_name}' would be #{expected_score}, but was #{actual_scores[team_name]}"
    end
  
    failure_message_when_negated do |actual_scores|
      "expected that scores for team '#{team_name}' would not be #{expected_score}"
    end
end