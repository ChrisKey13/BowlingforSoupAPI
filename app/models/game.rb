class Game < ApplicationRecord
    serialize :frames, type: Array, coder: YAML

    attr_accessor :current_frame, :current_roll, :state_manager, :state
  
    after_initialize :initialize_state

    MAX_PINS = 10
    FRAMES_PER_GAME = 10
  
    def roll(pins)
      return false unless valid_roll?(pins)
      execute_roll(pins)
      true
    end
    
    def rolls
      frames.flatten
    end
    
    private
    
    def initialize_state
      set_frames([])
      set_total_score(0)
      set_current_frame(1)
      set_current_roll(0)
      initialize_state_manager
    end
  
    def set_frames(value)
      self.frames = value
    end
  
    def set_total_score(value)
      self.total_score = value
    end
  
    def set_current_frame(value)
      @current_frame = value
    end
  
    def set_current_roll(value)
      @current_roll = value
    end
  
    def initialize_state_manager
      @state_manager = StateManager.new(self)
      self.state = RegularFrameState.new(self)
    end

    def execute_roll(pins)
      pass_roll_to_current_state(pins)
      proceed_to_next_state
    end

    def valid_roll?(pins)
      unless pins.between?(0, Game::MAX_PINS)
        errors.add(:base, "Invalid roll")
        return false
      end
      true      
    end

    def pass_roll_to_current_state(pins)
      state.roll(pins)
    end
    
    def proceed_to_next_state
      @state_manager.transition_to_next_state      
    end
end
  