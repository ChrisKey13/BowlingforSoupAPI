require 'rails_helper'

RSpec.describe 'GameSessions API', type: :request do
  describe 'POST /game_sessions' do
    let!(:player_attributes) { [{ name: "Alice" }, { name: "Bob" }] }

    it 'creates a new game session with players and starts a game for each' do
      post game_sessions_path, params: {
        game_session: {
          players_attributes: [
            { name: "Player 1" },
            { name: "Player 2" }
          ]
        }
      }
      puts response.status
      puts response.body
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)

      expect(json_response['players'].count).to eq(2)
      expect(Game.count).to eq(2) 
    end
  end

  describe 'GET /game_sessions/:id/winner' do
    let!(:game_session) { create(:game_session, :with_players) }

    it 'returns the winner of the game session' do
      get winner_game_session_path(game_session)

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json['id']).to eq(game_session.winner.id)
    end
  end
end
