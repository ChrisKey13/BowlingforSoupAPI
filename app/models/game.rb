class Game < ApplicationRecord
    serialize :frames, type: Array, coder: YAML
  
    after_initialize :set_defaults

    MAX_PINS = 10
    FRAMES_PER_GAME = 10
  
    def roll(pins)
      roll_manager = RollManager.new(self)
      roll_manager.add_roll(pins)
    end
  
    
    def rolls
      frames.flatten
    end
    
    private
    
    def set_defaults
      self.frames ||= []
      self.total_score ||= 0
    end
    
end
  