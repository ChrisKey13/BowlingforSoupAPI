module GameHelpers
    def roll_sequence(game, rolls)
      rolls.each { |pins| game.roll(pins) }
    end
end
  
RSpec.configure do |config|
    config.include GameHelpers
end