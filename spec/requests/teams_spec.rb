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
