require 'rails_helper'

RSpec.describe GameSession, type: :model do
  include_context 'game setup'

  before(:each) do
    Participation.delete_all
    puts "Cleaned up Participation records"
  end


  describe 'Associations' do
    it { is_expected.to have_many(:players).dependent(:destroy) }
    it { is_expected.to have_many(:games).through(:players) }
  end

  describe '#winner' do
    context 'when there is a clear winner' do
      include_context 'scored games setup'

      it 'returns the player with the highest score' do
        winning_player = game_session.players.max_by { |player| player.games.sum(:total_score) }
        expect(game_session.winner).to eq(winning_player)
      end
    end

    context 'when there is no game played' do
      it 'returns nil' do
        expect(game_session.winner).to be_nil
      end
    end
  end

  describe '#winners' do
    context 'when there are tied winners' do
      include_context 'with tied games setup'

      it 'returns all players with the highest score' do
        tied_players = game_session.winners
        expect(tied_players.length).to be > 1
        expect(tied_players).to all(be_a(Player))
      end
    end
  end

  describe 'Unique Team Participation' do
    include_context 'game with teams setup' 
  
    context 'with no initial participation' do
      before do
        Participation.delete_all
      end
  
      it "allows creating a new participation" do
        expect(game_session).to only_allow_unique_participation_for_team.for_team(team)
      end
    end
  
    context 'when participation already exists' do
      it "prevents duplicate team participation in the same game session" do
        expect(game_session).to only_allow_unique_participation_for_team.for_team(team)
      end
    end
  end
  
end
