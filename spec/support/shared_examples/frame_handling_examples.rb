RSpec.shared_examples 'frame handling' do |rolls, description|
    it "#{description}" do
      rolls.each { |pins| game.roll(pins) } # Use 'game' instead of 'subject' if it makes it clearer
      last_frame = game.frames.last
  
      if rolls.first == 10
        # Assuming a strike is when the first roll is 10
        expect(last_frame.first).to eq(10)
      elsif rolls.sum == 10 && rolls.size > 1
        # Assuming a spare is when the total is 10 but not on the first roll
        expect(last_frame.sum).to eq(10)
        expect(last_frame.first).not_to eq(10)
      else
        # For a regular frame without a spare or strike
        expect(last_frame.sum).to eq(rolls.sum)
      end
    end
  end
  