require 'rails_helper'

RSpec.describe "Searches", type: :request do
  include_context 'with indexed models'

  describe "GET /index" do
    it "returns relevant results for a given query" do
      get search_path, params: { query: "Alpha" }

      expect(response).to have_http_status(:ok)
      expect(response).to have_search_result(type: "team", name: "Alpha Team")
    end
  end

  describe "GET /index with fuzzy search" do
    context "when there are typos in the search query" do
      it "returns relevant team results despite typos" do
        get search_path, params: { query: "Alpah" }

        expect(response).to have_http_status(:ok)
        expect(response).to have_search_result(type: "team", name: "Alpha Team")
      end
    end

    context "when searching with added characters in the query" do
      it "returns relevant results despite extra characters" do
        get search_path, params: { query: "Alppha" } 

        expect(response).to have_http_status(:ok)
        expect(response).to have_search_result(type: "team", name: "Alpha Team")
      end
    end

    context "when searching with missing characters in the query" do
      it "returns relevant results despite missing characters" do
        get search_path, params: { query: "Alha" } 

        expect(response).to have_http_status(:ok)
        expect(response).to have_search_result(type: "team", name: "Alpha Team")
      end
    end

    context "when searching with slightly scrambled characters" do
      it "returns relevant results despite scrambled characters" do
        get search_path, params: { query: "Aplha" } 

        expect(response).to have_http_status(:ok)
        expect(response).to have_search_result(type: "team", name: "Alpha Team")
      end
    end
  end

  describe "GET /autocomplete" do
    include_context "with indexed models"

    before do
      Player.__elasticsearch__.create_index!(force: true)
      Team.__elasticsearch__.create_index!(force: true)
      Player.__elasticsearch__.import
      Team.__elasticsearch__.import
      Player.__elasticsearch__.refresh_index!
      Team.__elasticsearch__.refresh_index!
      sleep 1 
    end

    it "returns suggestions for 'Alph'" do
      get autocomplete_search_path, params: { query: "Alph" }

      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions.any? { |s| s["text"].start_with?("Alpha Team") }).to be true
    end

    it "returns suggestions for 'Joh'" do
      get autocomplete_search_path, params: { query: "Joh" }

      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions.any? { |s| s["text"] == "John Doe" }).to be true
    end

    it "returns suggestions regardless of query case" do
      get autocomplete_search_path, params: { query: "alph" } 
      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions.any? { |s| s["text"].start_with?("Alpha Team") }).to be true
    end

    it "returns no suggestions when there are no matches" do
      get autocomplete_search_path, params: { query: "zzz" }
      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions).to be_empty
    end 

    it "handles queries with special characters correctly" do
      get autocomplete_search_path, params: { query: "Alpha Team@" }
      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions.any? { |s| s["text"].include?("Alpha Team") }).to be true
    end
  end

  describe "GET /index with faceted search/filtering" do
    context "when filtering by team name" do
      it "returns results filtered by the specified team name" do
        get search_path, params: { query: "Alpha", team_name_filter: "Alpha Team" }

        expect(response).to have_http_status(:ok)
        results = JSON.parse(response.body)["results"]
        expect(results.all? { |result| result["attributes"]["name"].include?("Alpha Team") }).to be true
      end
    end

    context "when filtering games by score range" do
      it "returns games with scores within the specified range" do
        get search_path, params: { query: "", score_from: 50, score_to: 150 }

        expect(response).to have_http_status(:ok)
        results = JSON.parse(response.body)["results"]
        expect(results.all? { |result| result["type"] == "game" && result["attributes"]["score"].between?(50, 150) }).to be true
      end
    end

    context "when combining filters" do
      it "returns results that match all filters" do
        get search_path, params: { query: "Alpha", team_name_filter: "Alpha Team", score_from: 50, score_to: 150 }

        expect(response).to have_http_status(:ok)
        results = JSON.parse(response.body)["results"]
        expect(results.all? { |result| result["attributes"]["name"].include?("Alpha Team") && result["attributes"]["score"].between?(50, 150) }).to be true
      end
    end
  end
end
