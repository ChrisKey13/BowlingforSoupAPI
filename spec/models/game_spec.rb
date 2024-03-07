require 'rails_helper'

RSpec.describe Game, type: :model do
  include_context 'game setup'

  describe 'Special Scenarios' do
    it 'scores 300 points in a perfect game' do
      roll_sequence(game, Array.new(12, 10))
      expect(game).to have_total_score(300)
    end

    it 'scores 150 points with all spares' do
      roll_sequence(game, Array.new(21, 5))
      expect(game).to have_total_score(150)
    end

    it 'scores 0 points with all gutters' do
      roll_sequence(game, Array.new(20, 0))
      expect(game).to have_total_score(0)
    end
  end

  describe 'Scoring' do
    it 'correctly identifies a strike' do
      roll_sequence(game, [10])
      expect(game).to be_a_strike
    end

    it 'correctly identifies a spare' do
      roll_sequence(game, [7, 3])
      expect(game).to be_a_spare
    end

    it 'accumulates score correctly after a spare' do
      roll_sequence(game, [7, 3, 5])
      expect(game).to have_total_score(20)
    end

    it 'accumulates score correctly after a strike followed by regular hits' do
      roll_sequence(game, [10, 3, 6])
      expect(game).to have_total_score(28)
    end

    it 'handles a spare followed by a strike' do
      roll_sequence(game, [5, 5, 10])
      expect(game).to have_total_score(30)
    end

    it 'handles a strike followed by a spare' do
      roll_sequence(game, [10, 5, 5])
      expect(game).to have_total_score(30)
    end

    context 'with a sequence of strikes and spares' do
      it 'correctly calculates the total score' do
        roll_sequence(game, [10, 7, 3, 4, 6, 10, 2, 8, 5])
        expect(game).to have_total_score(94)
      end
    end

    context 'with multiple strikes' do
      it 'accumulates score correctly' do
        roll_sequence(game, Array.new(5, 10))
        expect(game).to have_total_score(120)
      end
    end

    context 'with multiple spares' do
      it 'accumulates score correctly' do
        roll_sequence(game, Array.new(5, [5, 5]).flatten)
        expect(game).to have_total_score(70) 
      end
    end
  end

  describe 'Input Validation and Frame Integrity' do
    context 'in regular frames' do
      it 'rejects a roll exceeding 10 pins' do
        roll_sequence(game, [11])
        game.valid?
        expect(game.errors[:base]).to include(match(/Cannot knock down more than 10 pins in a single roll/))
      end

      it 'rejects a frame where the total exceeds 10 pins' do
        roll_sequence(game, [5])
        expect { game.roll(6) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'in the final frame' do
      before do
        roll_sequence(game, Array.new(9, 0))
        game.valid?
      end

      it 'allows a strike in the final frame' do
        roll_sequence(game, [10])
        game.valid?
        expect(game.errors[:base]).to be_empty
      end

      it 'rejects a single roll exceeding 10 pins in the final frame' do
        roll_sequence(game, [11])
        game.valid?
        expect(game.errors[:base]).to include(match(/Cannot knock down more than 10 pins in a single roll/))
      end

      it 'allows the first two rolls to total more than 10 if a spare is scored' do
        roll_sequence(game, Array.new(2,5))
        game.valid?
        expect(game.errors[:base]).to be_empty
      end
    end
  end
end