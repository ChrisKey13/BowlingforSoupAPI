require 'rails_helper'

RSpec.describe GameScorer, type: :service do
  include_context 'game setup'

  describe 'roll handling' do
    context 'with valid rolls' do
      let(:pins) { 5 }

      it 'updates the game correctly' do
        game.roll(pins)
        expect(game.frames).to include([pins])
      end
    end

    context 'with invalid roll data' do
      shared_examples 'invalid roll handling' do |pins, error_message|
        it "rejects a roll of #{pins}" do
          game.roll(pins)
          expect(game.errors.full_messages).to include(error_message)
        end
      end

      include_examples 'invalid roll handling', 11, "Cannot knock down more than 10 pins in a single roll."
      include_examples 'invalid roll handling', -1, "Invalid roll: Pin count cannot be negative."
    end
  end
  describe '10th frame handling' do
    subject(:game) { create(:game) }
    before { 18.times { game.roll(1) } }
  
    include_examples 'frame handling', [10, 5, 4], 'correctly scores a strike followed by two bonus rolls'
    include_examples 'frame handling', [5, 5, 10], 'correctly scores a spare followed by a bonus roll'
    include_examples 'frame handling', [3, 4], 'correctly scores a regular frame without spare or strike'
  end
  
end
