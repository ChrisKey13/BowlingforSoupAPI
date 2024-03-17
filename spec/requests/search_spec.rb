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

    puts "Starting test setup"

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
      puts 'Making autocomplete request'
      get autocomplete_search_path, params: { query: "Alph" }
      puts "Response body: #{response.body}"

      expect(response).to have_http_status(:ok)
      suggestions = JSON.parse(response.body)["suggestions"]
      expect(suggestions.any? { |s| s["text"].start_with?("Alpha Team") }).to be true
      puts 'Test teardown'
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
end
