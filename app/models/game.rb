class Game < ApplicationRecord
    serialize :frames, type: Array, coder: YAML

    MAX_PINS = 10
    FRAMES_PER_GAME = 10

    attr_accessor :frame, :total_score, :current_frame, :current_roll, :state
  
    after_initialize :initialize_state

  
    def roll(pins)
      return false unless valid_roll?(pins)
      
      state.roll(pins)
      self.state = GameStateFactory.build_state(self)
      true
    end
    
    def rolls
      frames.flatten
    end
    
    private
    
    def initialize_state
      @frames = []
      @total_score = 0
      @current_frame = 0
      @current_roll = 0
      @state = GameStateFactory.build_state(self)
    end

    def valid_roll?(pins)
      unless pins.between?(0, Game::MAX_PINS)
        errors.add(:base, "Invalid roll")
        return false
      end
      true      
    end
end
  