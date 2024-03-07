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
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)

      expect(json_response['players'].count).to eq(2)
      expect(Game.count).to eq(2) 
    end
  end

  describe 'GET /game_sessions/:id/winner' do
    let!(:game_session) { create(:game_session, :game_session_with_scored_games) }

    it 'returns the winner of the game session' do
      get winner_game_session_path(game_session)
    
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
    
      if game_session.winner
        expect(json['winner']).to eq(game_session.winner.name)
      else
        expect(json['message']).to eq('No games have been played in this session.')
      end
    end
    
  end

  describe 'GET /game_sessions/:id/winner' do
    let!(:game_session) { create(:game_session) }
  
    it 'returns an appropriate message when no players are present' do
      get "/game_sessions/#{game_session.id}/winner"
      
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq('No players in this game session.')
    end
  end  

  describe 'GET /game_sessions/:id/winner' do
    let!(:game_session) { create(:game_session, :with_players) }
  
    it 'returns an appropriate message when no games have been played' do
      get "/game_sessions/#{game_session.id}/winner"

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq('No games have been played in this session.')
    end
  end

  describe 'GET /game_sessions/:id/winner' do
    context 'when there are tied winners' do
      let!(:game_session) { create(:game_session, :with_tied_games) }
      
      
      it 'returns all tied players as winners' do
        get "/game_sessions/#{game_session.id}/winner"
        
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json['winners'].length).to be > 1
        expect(json['winners'].first['id']).to eq(game_session.winners.first.id)
      end
    end
  end
  
  
  
end
