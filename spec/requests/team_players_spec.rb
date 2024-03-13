require 'rails_helper'

RSpec.describe "TeamPlayers", type: :request do
  include_context "team and player setup"

  describe "POST /teams/:team_id/team_players" do
    it "adds a player to the team" do
      player_id = @new_player.id
  
      expect {
        post team_team_players_path(@team.id), params: { team_player: { player_id: player_id } }
        @team.reload
      }.to change { @team.players.count }.by(1)
  
      expect(response).to have_http_status(:created)
    end

    it "prevents adding a player who is already in the team" do
      new_player = create(:player)
      @team.players << new_player
      expect {
        post team_team_players_path(@team.id), params: { team_player: { player_id: new_player.id } }
      }.not_to change { @team.reload.players.count }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /teams/:team_id/team_players/update_players" do
    it 'updates the team by adding new players and removing existing ones' do
      new_player = create(:player)
  
      patch update_players_team_team_players_path(@team), params: {
        team: {
          player_ids: [new_player.id] 
        }
      }
  
      @team.reload
  
      expect(response).to have_http_status(:ok)
      expect(@team.players).not_to include(@player)
      expect(@team.players).to include(new_player)
    end
  end
  

  describe "DELETE /teams/:team_id/team_players/:id" do
    it "removes a player from the team" do
      new_player = create(:player)
      @team.players << new_player
      team_player = @team.team_players.find_by(player_id: new_player.id)
  
      expect {
        delete team_team_player_path(@team, team_player)
      }.to change { @team.reload.players.count }.by(-1)
  
      expect(response).to have_http_status(:ok)
      expect(@team.players).not_to include(new_player)
    end
  
    it "does nothing if the player is not part of the team" do
      outside_player = create(:player) 
  
      expect {
        delete team_team_player_path(@team, outside_player.id)
      }.to change { @team.reload.players.count }.by(0)
  
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
end
