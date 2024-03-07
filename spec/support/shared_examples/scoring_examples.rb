
RSpec.shared_examples 'a scoring scenario' do |rolls, expected_score, frame_check = nil|
    it "scores #{expected_score} points" do
      roll_sequence(rolls)
      expect(subject).to have_total_score(expected_score)
      expect(subject).to be_in_frame(frame_check) unless frame_check.nil?
    end
  end
  