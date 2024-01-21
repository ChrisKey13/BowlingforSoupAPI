module BowlingValidation
    extend ActiveSupport::Concern
  
    included do
        validate :validate_current_roll_attempt
    end
  
    def validate_current_roll_attempt
        return if current_roll_attempt.nil?

        if current_roll_attempt < 0
            errors.add(:base, "Invalid roll: Pin count cannot be negative.")
            return
        end
  
        if current_frame < GameConstraints.instance.frames_per_game - 1
            validate_regular_frame_roll(current_roll_attempt)
        else
            validate_final_frame_roll(current_roll_attempt)
        end
    end
  
    private
  
    def validate_regular_frame_roll(pins)
        frame = frames[current_frame] || []

        if pins > GameConstraints.instance.max_pins
            errors.add(:base, "Cannot knock down more than #{GameConstraints.instance.max_pins} pins in a single roll.")
        elsif (frame.sum + pins) > GameConstraints.instance.max_pins && frame.count < 2
            errors.add(:base, "Total pins in frame #{current_frame + 1} cannot exceed #{GameConstraints.instance.max_pins}.")
        end
    end
  
    def validate_final_frame_roll(pins)
        frame = frames[current_frame] || []
        
        if pins > GameConstraints.instance.max_pins
            errors.add(:base, "Cannot knock down more than #{GameConstraints.instance.max_pins} pins in a single roll in the final frame.")
        elsif frame.count < 2 && (frame.sum + pins) > GameConstraints.instance.max_pins
            errors.add(:base, "The first two rolls in the final frame cannot exceed #{GameConstraints.instance.max_pins} pins unless rolling a spare.")
        end
    end
end
  