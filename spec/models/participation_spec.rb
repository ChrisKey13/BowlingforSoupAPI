require "rails_helper"

RSpec.describe Participation, type: :model do
    describe 'associations' do
        it { is_expected.to belong_to(:team) }
        it { is_expected.to belong_to(:game_session) }
    end 

    describe 'validations' do
        subject { create(:participation) }
        it { is_expected.to validate_uniqueness_of(:team_id).scoped_to(:game_session_id) }
    end
end