RSpec.shared_context 'game setup' do
    let(:game_session) { create(:game_session) }
    let(:player) { create(:player, game_session: game_session) }
    let(:game) { create(:game, player: player) }
end
  
RSpec.shared_context 'scored games setup' do
    let!(:game_session) do
      create(:game_session, :game_session_with_scored_games)
    end
end
  
RSpec.shared_context 'with tied games setup' do
    let!(:game_session) do
      create(:game_session, :with_tied_games)
    end
end

RSpec.shared_context "game setup for API" do
  let!(:game_session) { create(:game_session, :with_players) }
  let!(:player) { game_session.players.first }
  let!(:game) { create(:game, player: player) }
end

RSpec.shared_context "game with teams setup" do
  let!(:game_session) { create(:game_session) }
  let!(:team) { create(:team) }
  let!(:player) { create(:player, game_session: game_session) }
  let!(:team_player) { create(:team_player, team: team, player: player) }
  let!(:participation) { create(:participation, team: team, game_session: game_session) }
end