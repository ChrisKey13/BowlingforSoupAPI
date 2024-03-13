require 'rails_helper'

RSpec.describe "Teams", type: :request do
  include_context "game with teams setup"
  
  describe "POST /teams" do
    it "creates a new team" do
      expect {
        post teams_path, params: { team: { name: 'New Team' } }
      }.to change(Team, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
  
  describe "GET /teams/:id" do
    it "retrieves a specific team and its players" do
      get team_path(team)
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(team.name)

      player_names = json_response['players'].map { |p| p['name'] }
      expect(player_names).to include(player.name)
    end
  end
end

RSpec.describe "Teams", type: :request do
  include_context "team and player setup"

  describe "PATCH /teams/:id/update_players" do

    before do
      @team.players << @new_player
    end

    it 'does not add duplicate players to the team' do
      expect(@team.players).to include(@new_player) 
      initial_player_count = @team.players.count

      expect {
        puts "Before PATCH request: Team players count = #{initial_player_count}"
        
        patch team_path(@team), params: { 
          team: { 
            player_ids: @team.players.pluck(:id) + [@new_player.id] 
          } 
        }

        @team.reload 
      }.not_to change { @team.players.count } 

      expect(@team.players).to include(@new_player)
      expect(@team.players.count).to eq(initial_player_count) 
    end

    it 'maintains existing players when no player_ids are passed' do
      patch team_path(@team), params: { team: { name: 'Updated Team Name' } }
      expect(@team.reload.players).to include(@player)
    end
  end
end