class RollManager
    def initialize(game)
      @game = game
    end
  
    def add_roll(pins)
      return false unless valid_roll?(pins)
  
      @game.frames << [] if new_frame_needed?
      @game.frames.last << pins
      update_total_score
      true
    end
  
    private
  
    def new_frame_needed?
      @game.frames.empty? || frame_complete?(@game.frames.last)
    end
  
    def frame_complete?(frame)
      frame.count == 2 || frame.first == Game::FRAMES_PER_GAME
    end
  
    def valid_roll?(pins)
      pins.between?(0, Game::MAX_PINS) && (@game.frames.empty? || @game.frames.last.sum + pins <= Game::MAX_PINS)
    end
  
    def update_total_score
      @game.total_score = GameScorer.new(@game).calculate
      @game.save
    end
end
  