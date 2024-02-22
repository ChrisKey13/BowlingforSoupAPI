require 'rails_helper'

RSpec.describe GameplayManager, type: :service do
  include_context 'game setup'

  context 'when advancing frames' do
    it 'remains in the first frame after the first regular roll' do
      game.roll(3)
      expect(game.current_frame).to eq(0)
    end

    it 'advances to the second frame after two regular rolls' do
      game.roll(3)
      game.roll(4)
      expect(game.current_frame).to eq(1)
    end

    it 'advances to the second frame after a spare' do
      game.roll(7)
      game.roll(3)
      expect(game.current_frame).to eq(1)
    end

    it 'advances to the second frame after a strike' do
      game.roll(10)
      expect(game.current_frame).to eq(1)
    end
  end
end
