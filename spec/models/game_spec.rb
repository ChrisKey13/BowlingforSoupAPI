require 'rails_helper'

RSpec.describe Game, type: :model do
  include_context 'game setup'

  describe 'Special Scenarios' do
    context 'with all strikes (a perfect game)' do
      it 'scores 300 points' do
        12.times { game.roll(10) }
        expect(game.total_score).to eq(300)
      end
    end

    context 'with all spares' do
      it 'scores 150 points' do
        21.times { game.roll(5) }
        expect(game.total_score).to eq(150)
      end
    end

    context 'with all gutters' do
      it 'scores 0 points' do
        20.times { game.roll(0) }
        expect(game.total_score).to eq(0)
      end
    end
  end

  describe 'Scoring' do
    context 'with a spare followed by a regular hit' do
      before do
        game.roll(7)
        game.roll(3)
        game.roll(5)
      end

      it { expect(game).to have_total_score(20) }
    end

    context 'with a strike followed by regular hits' do
      before do
        game.roll(10)
        game.roll(3)
        game.roll(6)
      end

      it { expect(game).to have_total_score(28) }
    end

    context 'with multiple strikes' do
      before do
        3.times { game.roll(10) }
      end

      it { expect(game).to have_total_score(60) }
    end

    context 'in the 10th frame' do
      context 'with a strike and bonus rolls' do
        before do
          18.times { game.roll(0) }
          game.roll(10)
          game.roll(5)
          game.roll(4)
        end

        it { expect(game).to have_total_score(19) }
      end

      context 'with a spare and bonus roll' do
        before do
          18.times { game.roll(0) }
          game.roll(5)
          game.roll(5)
          game.roll(10)
        end

        it { expect(game).to have_total_score(20) }
      end
    end
  end

  describe 'Input Validation and Frame Integrity' do
    context 'in regular frames' do
      it 'rejects a roll exceeding 10 pins' do
        game.roll(11)
        game.valid? 
        expect(game.errors[:base]).to include(match(/Cannot knock down more than 10 pins in a single roll/))
      end

      it 'rejects a frame where the total exceeds 10 pins' do
        game.roll(5)
        game.roll(6)
        expect(game).not_to be_valid
      end
    end

    context 'in the final frame' do
      before do
        18.times { game.roll(0) }
        game.valid? 
      end

      it 'allows a strike in the final frame' do
        game.roll(10)
        game.valid? 
        expect(game.errors[:base]).to be_empty
      end

      it 'rejects a single roll exceeding 10 pins in the final frame' do
        game.roll(11)
        game.valid? 
        expect(game.errors[:base]).to include(match(/Cannot knock down more than 10 pins in a single roll in the final frame/))
      end

      it 'allows the first two rolls to total more than 10 if a spare is scored' do
        game.roll(5)
        game.roll(5) 
        game.valid? 
        expect(game.errors[:base]).to be_empty
      end
    end
  end
end
