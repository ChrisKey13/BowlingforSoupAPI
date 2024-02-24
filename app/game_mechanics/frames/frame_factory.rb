class FrameFactory
  FRAME_TYPES = [StrikeFrame, SpareFrame]

  def self.create(rolls, next_rolls)
    frame_class = FRAME_TYPES.find(-> { NormalFrame }) do |frame_type|
      frame_type.valid?(rolls, next_rolls)
    end
    frame_class.new(rolls, next_rolls)
  end
end
