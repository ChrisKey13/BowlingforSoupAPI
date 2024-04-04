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

RSpec.shared_context 'game session with teams and players', shared_context: :metadata do
  let!(:game_session) { create(:game_session) }
  let!(:team1) { create(:team) }
  let!(:team2) { create(:team) }

  let!(:player1) { create_player_in_game_session(team: team1) }
  let!(:player2) { create_player_in_game_session(team: team2, total_score: 150) }

  def create_player_in_game_session(team:, total_score: 100)
    player = create(:player, game_session: game_session)
    game = create(:game, player: player, total_score: total_score)
    create(:team_player, team: team, player: player)
    create(:participation, team: team, game_session: game_session)
    player
  end
end

RSpec.shared_context 'TeamScorer Setup' do
  let!(:game_session) { create(:game_session) }
  let!(:team1) { create(:team, name: 'Team 1') }
  let!(:team2) { create(:team, name: 'Team 2') }

  before do
    create(:participation, team: team1, game_session: game_session)
    create(:participation, team: team2, game_session: game_session)
  end
  
  def setup_team_with_scores(team, scores)
    scores.each do |score|
      player = create(:player, game_session: game_session)
      create(:game, player: player, total_score: score, game_session: game_session)
      create(:team_player, team: team, player: player)
    end
  end
end

RSpec.shared_context 'game session with team scores' do
  let!(:game_session) { create(:game_session) }
  let!(:teams) { create_list(:team, 2) }

  before do
    teams.each_with_index do |team, index|
      player = create(:player, game_session: game_session)
      create(:team_player, team: team, player: player)
      create(:game, player: player, total_score: 100 * (index + 1), game_session: game_session)
      create(:participation, team: team, game_session: game_session)
    end
  end
end 


RSpec.shared_context 'game session with scores' do
  let!(:game_session) { create(:game_session) }
  let!(:players) { create_list(:player, 2, game_session: game_session) }

  before do
    players.each_with_index do |player, index|
      create(:game, player: player, total_score: 50 * (index + 1), game_session: game_session)
    end
  end
end  

RSpec.shared_context 'game session with tied team scores' do
  let!(:game_session) { create(:game_session) }
  let!(:team1) { create(:team) }
  let!(:team2) { create(:team) }

  before do
    tied_score = 150

    player1_team1 = create(:player, game_session: game_session)
    create(:game, player: player1_team1, total_score: tied_score, game_session: game_session)
    create(:team_player, team: team1, player: player1_team1)
    create(:participation, team: team1, game_session: game_session)

    player1_team2 = create(:player, game_session: game_session)
    create(:game, player: player1_team2, total_score: tied_score, game_session: game_session)
    create(:team_player, team: team2, player: player1_team2)
    create(:participation, team: team2, game_session: game_session)
  end
  let(:expected_team_one) { team1 }
  let(:expected_team_two) { team2 }
end

RSpec.shared_context 'game session with team winner setup' do
  let!(:game_session) { create(:game_session) }
  let!(:team1) { create(:team, name: 'Team A') }
  let!(:team2) { create(:team, name: 'Team B') }
  let!(:player1_team1) { create(:player, game_session: game_session) }
  let!(:player2_team2) { create(:player, game_session: game_session) }

  before do
    create(:game, player: player1_team1, total_score: 100, game_session: game_session)
    create(:game, player: player2_team2, total_score: 50, game_session: game_session)
    create(:team_player, team: team1, player: player1_team1)
    create(:team_player, team: team2, player: player2_team2)
    create(:participation, team: team1, game_session: game_session)
    create(:participation, team: team2, game_session: game_session)
  end

  let(:expected_winning_team) { team1 }
end


RSpec.shared_context 'with indexed models', shared_context: :metadata do
  before do
    [GameSession, Game, Participation, Player, TeamPlayer, Team].each do |model|
      model.__elasticsearch__.client.indices.delete(index: model.__elasticsearch__.index_name, ignore_unavailable: true)
      model.__elasticsearch__.create_index!(force: true)
      model.__elasticsearch__.import
      model.__elasticsearch__.refresh_index!
      model.__elasticsearch__.client.indices.refresh(index: model.__elasticsearch__.index_name)

    end

    game_session = GameSession.create!
    unique_team_name = "Alpha Team #{Time.now.to_i}"
    team = Team.create!(name: unique_team_name)
    player = Player.create!(name: "John Doe", game_session: game_session)
    Game.create!(total_score: 100, player: player, game_session: game_session)
    Participation.create!(team: team, game_session: game_session)
    TeamPlayer.create!(team: team, player: player)

    [GameSession, Game, Participation, Player, TeamPlayer, Team].each do |model|
      model.__elasticsearch__.import
      model.__elasticsearch__.refresh_index!
    end

    sleep 2
    puts "[Debug] Indexed models setup complete. Indexed Team name: #{Team.last.name}"
  end
end
