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
        expect(game.score).to eq(37)
      end
    end
  end

  describe 'score calculation' do
    context 'for consecutive strikes' do
      it 'correctly calculates score' do
        3.times { game.roll(10) }
        expect(game.score).to eq(60)
      end
    end
    
    it 'does not finish the game prematurely' do
        9.times { game.roll(10) } 
        expect(game).not_to be_finished_game
    end
      
    it 'finishes the game after 10 frames without strikes or spares in the 10th frame' do
        9.times { game.roll(10) } 
        game.roll(3)  
        game.roll(4) 
        expect(game).to be_finished_game
    end

    it 'identifies the end of the game correctly' do
      12.times { game.roll(10) }
      expect(game.score).to eq(300)
      expect(game).to be_finished_game
    end

  end
end
