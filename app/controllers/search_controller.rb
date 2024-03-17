class SearchController < ApplicationController
  def index
    @results = []

    if params[:query].present?
      query = params[:query].strip

      search_definition = {
        query: {
          bool: {
            must: {
              multi_match: {
                query: query,
                fields: ['name^2', 'description', 'model_type'],
                fuzziness: "AUTO"
              }
            },
            filter: []
          }
        },
        highlight: {
          fields: {
            name: {}
          }
        }
      }

      if params[:team_name_filter].present?
        search_definition[:query][:bool][:filter] << {
          term: { 'team_name.keyword': params[:team_name_filter] }
        }
      end

      score_range = {}
      score_range[:gte] = params[:score_from] if params[:score_from].present?
      score_range[:lte] = params[:score_to] if params[:score_to].present?

      search_definition[:query][:bool][:filter] << { range: { score: score_range } } unless score_range.empty?

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

          suggestions = results.suggest['name_suggestion'][0]['options'].map do |option|
            { text: option['text'], score: option['_score'] }
          end
        end
    
        render json: { suggestions: suggestions }, status: :ok
    end
  end
  