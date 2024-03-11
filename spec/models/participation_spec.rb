require "rails_helper"

RSpec.describe Participation, type: :model do
  let!(:team) { create(:team) }
  let!(:game_session) { create(:game_session) }

  describe 'associations' do
    it { is_expected.to belong_to(:team) }
    it { is_expected.to belong_to(:game_session) }
  end

  describe 'validations' do
    subject { create(:participation) }
    it { is_expected.to validate_uniqueness_of(:team_id).scoped_to(:game_session_id) }
  end

  describe 'Participation uniqueness validation' do
    include_context 'game with teams setup' 
  
    context 'when a participation already exists' do
      it 'prevents creating a duplicate participation' do
        expect(game_session).to only_allow_unique_participation_for_team.for_team(team)
      end
    end
  
    context 'when no participation exists' do
      before { Participation.delete_all }
  
      it 'allows creating a new participation' do
        expect(game_session).to only_allow_unique_participation_for_team.for_team(team)
      end
    end
  end
  

end
