require 'rails_helper'

RSpec.describe "Participations", type: :request do
  include_context 'game with teams setup'

  describe "POST /participations" do
    before do
      post participations_path, params: { participation: { team_id: team.id, game_session_id: game_session.id } }
    end

    it "prevents a team from joining the same game session more than once" do
      expect {
        post participations_path, params: { participation: { team_id: team.id, game_session_id: game_session.id } }
      }.not_to change(Participation, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
