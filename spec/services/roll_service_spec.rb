require 'rails_helper'

RSpec.describe RollService do
  let!(:game) { create(:game) }
  let(:game_context) { GameContext.new(game) }
  let(:roll_service) { described_class.new(game_context) }

  describe '#add_roll' do
    context 'regular frames' do
        it 'adds a roll to the current frame correctly' do
            roll_service.add_roll(4)
            expect(game.frames).to eq([[4]])
        end
          
        it 'correctly adds multiple rolls across frames' do
            [3, 6, 7, 2, 4].each { |pins| roll_service.add_roll(pins) }
            
            expected_frames = [[3, 6], [7, 2], [4]]
            expect(game.frames).to eq(expected_frames)
            
            expect(game.current_frame).to eq(2)
        end
          
        it 'advances to the next frame after two rolls' do
            2.times { roll_service.add_roll(4) }
            expect(game.current_frame).to eq(1) 
        end

        it 'handles a strike by advancing to the next frame immediately' do
            roll_service.add_roll(10)
            expect(game.current_frame).to eq(1)
        end
    end

    context 'final frame' do
      before { 18.times { roll_service.add_roll(1) } }

      it 'allows up to three rolls if the first roll is a strike' do
        3.times { roll_service.add_roll(10) }
        expect(game.frames.last).to match_array([10, 10, 10])
      end
    end

    context 'error handling' do
        it 'raises an error for an invalid roll' do
            expect { roll_service.add_roll(11) }.to raise_error(StandardError, /Invalid number of pins:/)
        end
    end
  end
end
