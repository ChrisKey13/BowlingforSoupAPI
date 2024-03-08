require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  include_context 'game setup for API'

  let(:base_url) { "/game_sessions/#{game_session.id}/games/#{game.id}" }

  describe 'PATCH /games/:id/roll' do
    context 'with a valid roll' do
      before { patch "#{base_url}/roll", params: { game: { pins: 4 } } }

      it 'updates the game and returns success' do
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["frames"]).to include([4])
      end
    end

    context 'with an invalid roll' do
      before { patch "#{base_url}/roll", params: { game: { pins: 11 } } }

      it 'rejects the roll and returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /games/:id' do
    before { get base_url }

    it 'retrieves the current game status' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include("frames" => [], "total_score" => 0)
    end
  end
end
