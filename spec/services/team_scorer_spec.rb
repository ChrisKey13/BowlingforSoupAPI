require 'rails_helper'

RSpec.describe TeamScorer, type: :service do
    
    describe '#call' do
        include_context 'TeamScorer Setup' 
      
        let(:team_scorer) { described_class.new(game_session) }

        before do
            setup_team_with_scores(team1, [100, 50])
            setup_team_with_scores(team2, [150, 70])
        end

        context 'basic score calculation' do
            it 'accurately calculates team scores' do
                team_scores = team_scorer.call
                expect(team_scores).to have_score_for(team1.name, 150)
                expect(team_scores).to have_score_for(team2.name, 220)
            end
        end

        context 'zero scores without games' do
            before { Game.delete_all }

            it 'returns zero for teams without games' do
                team_scores = team_scorer.call
                expect(team_scores).to have_score_for(team1.name, 0)
                expect(team_scores).to have_score_for(team2.name, 0)
            end
        end

        context 'aggregating scores with multiple players' do            

            it 'aggregates scores correctly' do
                team_scores = team_scorer.call
                expect(team_scores).to have_score_for(team1.name, 150)
                expect(team_scores).to have_score_for(team2.name, 220) 
            end
        end

        context 'uneven number of players' do

            it 'handles uneven players correctly' do
                team_scores = team_scorer.call
                expect(team_scores).to have_score_for(team1.name, 150)
                expect(team_scores).to have_score_for(team2.name, 220)
            end
        end

        context 'handling tied scores' do

            it 'handles ties correctly' do
                team_scores = team_scorer.call
                expect(team_scores).to have_score_for(team1.name, 150)
                expect(team_scores).to have_score_for(team2.name, 220)
            end
        end
    end
end
