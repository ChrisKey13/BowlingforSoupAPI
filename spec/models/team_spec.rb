require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:team_players).dependent(:destroy) }
    it { is_expected.to have_many(:players).through(:team_players) }
    it { is_expected.to have_many(:participations).dependent(:destroy) }
    it { is_expected.to have_many(:game_sessions).through(:participations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
