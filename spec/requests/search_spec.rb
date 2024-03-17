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
end
