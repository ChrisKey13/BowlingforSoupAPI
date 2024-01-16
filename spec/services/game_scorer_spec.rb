require 'rails_helper'

RSpec.describe GameScorer, type: :service do
  include_context 'game setup'

  describe 'roll handling' do
    context 'with valid rolls' do
      it 'updates the game correctly' do
        game.roll(5)
        expect(game.frames).to include([5])
      end
    end

    context 'with invalid roll data' do
      it 'rejects a roll with more than 10 pins' do
        expect(game.roll(11)).to be false
      end

      it 'rejects a roll with negative pin count' do
        expect(game.roll(-1)).to be false
      end
    end

    context 'in the 10th frame' do
      before { 18.times { game.roll(1) } }

      it 'handles strike and bonus rolls correctly' do
        game.roll(10)
        game.roll(5)
        game.roll(4)
        expect(game.total_score).to eq(27)
      end
    end
  end

end
