require 'rails_helper'

RSpec.describe Player, type: :model do
  include_context 'game setup'

  describe 'Associations' do
    it { is_expected.to belong_to(:game_session) }
    it { is_expected.to have_many(:games).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'Methods' do
    describe '#create_initial_game' do
      context 'after creating a player' do
        let!(:new_player) { create(:player, game_session: game_session) }

        it 'automatically creates an initial game for the player' do
          expect(new_player.games.count).to eq(1)
        end
      end
    end
  end
end
