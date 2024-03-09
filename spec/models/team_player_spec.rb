require 'rails_helper'

RSpec.describe TeamPlayer, type: :model do
    describe 'associations' do
        it { is_expected.to belong_to(:team) }
        it { is_expected.to belong_to(:player) }
    end

    describe 'validations' do
        subject { create(:team_player) }
        it { is_expected.to validate_uniqueness_of(:player_id).scoped_to(:team_id)  }
    end
end