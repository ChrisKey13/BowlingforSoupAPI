module BowlingValidation
  extend ActiveSupport::Concern

  MAX_PINS = GameConstraints.instance.max_pins
  
  included do
    validate :validate_current_roll_attempt, if: -> { current_roll_attempt.present? }
  end
  
  def validate_current_roll_attempt
    validate_roll_value
    validate_frame_total
  end
  
  private
  
  def validate_roll_value
    errors.add(:base, "Invalid roll: Pin count cannot be negative.") if current_roll_attempt.negative?
    errors.add(:base, "Cannot knock down more than #{MAX_PINS} pins in a single roll.") if current_roll_attempt > MAX_PINS
  end
  
  def validate_frame_total
    frame = frames[current_frame] || []
    errors.add(:base, "Total pins in frame #{current_frame + 1} cannot exceed #{MAX_PINS}.") if frame.sum > MAX_PINS && !is_spare_or_strike?(frame)
  end

  def is_spare_or_strike?(frame, objective=MAX_PINS)
    frame.first == objective || frame.sum + current_roll_attempt == objective
  end
end
