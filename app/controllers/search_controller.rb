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

    def autocomplete
      puts "In SearchController#autocomplete with params: #{params.inspect}"
        query = params[:query].strip
        suggestions = []
    
        if query.present?
          search_definition = {
            suggest: {
              text: query,
              name_suggestion: {
                prefix: query,
                completion: {
                  field: 'name_suggest', 
                  fuzzy: {
                    fuzziness: "AUTO"
                  },
                  skip_duplicates: true
                }
              }
            }
          }
    
          results = Elasticsearch::Model.search(search_definition, [Player, Team]).response
          puts 'Fetching autocomplete suggestions'
          puts "Elasticsearch query: #{search_definition.inspect}"
          puts "Elasticsearch response: #{results.inspect}"

          suggestions = results.suggest['name_suggestion'][0]['options'].map do |option|
            { text: option['text'], score: option['_score'] }
          end
          puts "Autocomplete suggestions: #{suggestions.inspect}"
        end
    
        render json: { suggestions: suggestions }, status: :ok
    end
  end
  