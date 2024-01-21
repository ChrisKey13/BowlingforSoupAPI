require 'rails_helper'

RSpec.describe GameScorer, type: :service do
  include_context 'game setup'

  describe 'GameScorer' do
    let(:game) { Game.create }
  end
  

  describe 'roll handling' do
    context 'with valid rolls' do
      it 'updates the game correctly' do
        game.roll(5)
        expect(game.frames).to include([5])
      end
    end

    context 'with invalid roll data' do
      it 'rejects a roll with more than 10 pins' do
        game.roll(11)
        expect(game.errors.full_messages).to include("Cannot knock down more than 10 pins in a single roll.")
      end
  
      it 'rejects a roll with negative pin count' do
        game.roll(-1)
        expect(game.errors.full_messages).to include("Invalid roll: Pin count cannot be negative.")
      end
    end

    context 'in the 10th frame' do
      before { 18.times { game.roll(1) } }

      it 'handles strike and bonus rolls correctly' do
        game.roll(10)
        game.roll(5)
        game.roll(4)
        expect(game.total_score).to eq(37)
      end

      it 'handles no strike and no spare correctly' do
        game.roll(8)
        game.roll(1)
      end
      
    end


  end

end
