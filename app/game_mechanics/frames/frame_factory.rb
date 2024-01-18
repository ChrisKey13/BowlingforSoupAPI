class FrameFactory
  def self.create(rolls, next_rolls)
    [StrikeFrame, SpareFrame, NormalFrame].each do |frame_class|
      frame = frame_class.create(rolls, next_rolls)
      return frame if frame
    end
  end
end
