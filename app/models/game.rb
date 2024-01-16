class Game < ApplicationRecord
    serialize :frames, type: Array, coder: YAML
  
    after_initialize :set_defaults
  
    def roll(pins)
      return false unless valid_roll?(pins)
  
      frames << [] if frames.empty? || frame_complete?(frames.last)
      frames.last << pins
      update_total_score # Update the total score when rolling.
      true
    end
  
    def update_total_score
      self.total_score = GameScorer.new(self).calculate
      save
    end

    def rolls
        frames.flatten
    end
  
    private
  
    def set_defaults
      self.frames ||= []
      self.total_score ||= 0
    end
  
    def valid_roll?(pins)
      pins.between?(0, 10) && (frames.empty? || frames.last.sum + pins <= 10)
    end
  
    def frame_complete?(frame)
      frame.count == 2 || frame[0] == 10
    end
end
  