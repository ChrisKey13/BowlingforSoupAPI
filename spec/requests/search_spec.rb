require 'rails_helper'

RSpec.describe "Searches", type: :request do
  describe "GET /index" do
    include_context "with indexed models"

    it "returns relevant results for a given query" do
      get search_path, params: { query: "Alpha" }

      expect(response).to have_http_status(:ok)
      expect(response).to have_search_result(type: "team", name: "Alpha")
    end
  end
end
