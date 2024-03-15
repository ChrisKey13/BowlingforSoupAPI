require 'rails_helper'

RSpec.describe GameSessions::WinnerCalculator, type: :service do
    context 'for individual games' do
        include_context 'game session with scores'

        it 'returns an IndividualWinnerCalculator instance' do
            calculator = GameSessions::WinnerCalculator.for(game_session)
            expect(calculator).to be_a(GameSessions::IndividualWinnerCalculator)
        end
    end

    context 'for team games' do
        include_context 'game session with team scores'

        it 'returns a TeamWinnerCalculator instance' do
            calculator = GameSessions::WinnerCalculator.for(game_session)
            expect(calculator).to be_a(GameSessions::TeamWinnerCalculator)
        end
    end
end
