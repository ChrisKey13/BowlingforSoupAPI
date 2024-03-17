class SearchController < ApplicationController
    def index
      @results = []
  
      if params[:query].present?
        query = params[:query].strip
  
        search_definition = {
          query: {
            multi_match: {
              query: query,
              fields: ['name^2', 'description', 'model_type'],
              fuzziness: "AUTO"
            }
          },
            highlight: { 
                fields: {
                    name: {}
                }
            }
        }
  
        results = Elasticsearch::Model.search(search_definition, [GameSession, Game, Participation, Player, TeamPlayer, Team]).results
  
        @results = results.map do |result|
          source = result._source.as_json
          {
            id: result._id,
            type: source['model_type'],
            attributes: source.except('id', 'model_type') 
          }
        end
      end
  
      render json: { results: @results }, status: :ok
    end
  end
  