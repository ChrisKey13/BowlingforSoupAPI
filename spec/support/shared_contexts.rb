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

RSpec.shared_context "team and game setup" do
  before do
    @game_session = create(:game_session)
    @team = create(:team)
    @player1 = create(:player)
    @player2 = create(:player)
    @team_player1 = create(:team_player, team: @team, player: @player1)
    @team_player2 = create(:team_player, team: @team, player: @player2)
    @participation = create(:participation, team: @team, game_session: @game_session)
  end
end

RSpec.shared_context "team and player setup" do
  before do
    @game_session = create(:game_session)
    @team = create(:team)
    @player = create(:player)
    create(:team_player, team: @team, player: @player)
    @new_player = create(:player) 
  end
end