require 'rails_helper'

RSpec.describe 'Games API', type: :request do

  describe 'PATCH /games/:id/roll' do
    let!(:game_session) { create(:game_session, :with_players) }
    let!(:player) { game_session.players.first }
    let!(:game) { create(:game, player: player) }

    it 'updates the game with a valid roll' do
        patch "/game_sessions/#{game_session.id}/games/#{game.id}/roll", params: { game: { pins: 4 } }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["frames"]).to include([4])
    end

    it 'rejects an invalid roll' do
      patch "/game_sessions/#{game_session.id}/games/#{game.id}/roll", params: { game: { pins: 11 } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
     
  end

  describe 'GET /games/:id' do
    let!(:game_session) { create(:game_session, :with_players) }
    let!(:player) { game_session.players.first }
    let!(:game) { create(:game, player: player) }

    it 'retrieves the current game status' do
      puts "Game ID: #{game.id}" 
      get "/game_sessions/#{game_session.id}/games/#{game.id}"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("frames" => [], "total_score" => 0)
    end
  end
end
