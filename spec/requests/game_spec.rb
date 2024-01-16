require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  describe 'POST /games' do
    it 'creates a new game' do
      post '/games'
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("frames" => [], "total_score" => 0)
    end
  end

  describe 'PATCH /games/:id/roll' do
    let!(:game) { create(:game) }

    it 'updates the game with a valid roll' do
      patch "/games/#{game.id}/roll", params: { pins: 4 }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["frames"]).to include([4])
    end

    it 'rejects an invalid roll' do
      patch "/games/#{game.id}/roll", params: { pins: 11 }
      expect(response).to have_http_status(:unprocessable_entity)
    end
      
  end

  describe 'GET /games/:id' do
    let!(:game) { create(:game) }

    it 'retrieves the current game status' do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("frames" => [], "total_score" => 0)
    end
  end
end
