# class SearchController < ApplicationController
#   def index
#     cache_key = build_cache_key(params)

#     @results = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
#       perform_search
#     end

#     render json: { results: @results }, status: :ok
#   end

#   def autocomplete
#     cache_key = "autocomplete_#{params[:query].strip.downcase}"

#     suggestions = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
#       perform_autocomplete_search
#     end

#     render json: { suggestions: suggestions }, status: :ok
#   end

#   private

#   def build_cache_key(params)
#     "search:#{params.to_json}"
#   end

#   def perform_search
#     query = params[:query].strip

#     search_definition = {
#       query: {
#         bool: {
#           must: {
#             multi_match: {
#               query: query,
#               fields: ['name^2', 'description', 'model_type'],
#               fuzziness: "AUTO"
#             }
#           },
#           filter: build_filters
#         }
#       },
#       highlight: {
#         fields: {
#           name: {}
#         }
#       }
#     }

#     Elasticsearch::Model.search(search_definition, [GameSession, Game, Participation, Player, TeamPlayer, Team]).results.map do |result|
#       source = result._source.as_json
#       {
#         id: result._id,
#         type: source['model_type'],
#         attributes: source.except('id', 'model_type')
#       }
#     end
#   end

#   def perform_autocomplete_search
#     query = params[:query].strip

#     search_definition = {
#       suggest: {
#         text: query,
#         name_suggestion: {
#           prefix: query,
#           completion: {
#             field: 'name_suggest',
#             fuzzy: {
#               fuzziness: "AUTO"
#             },
#             skip_duplicates: true
#           }
#         }
#       }
#     }

#     Elasticsearch::Model.search(search_definition, [Player, Team]).response.suggest['name_suggestion'][0]['options'].map do |option|
#       { text: option['text'], score: option['_score'] }
#     end
#   end

#   def build_filters
#     filters = []
#     filters << { term: { 'team_name.keyword': params[:team_name_filter] } } if params[:team_name_filter].present?

#     score_range = {}
#     score_range[:gte] = params[:score_from] if params[:score_from].present?
#     score_range[:lte] = params[:score_to] if params[:score_to].present?
#     filters << { range: { score: score_range } } unless score_range.empty?

#     filters
#   end
# end

class SearchController < ApplicationController
  def index
    puts "[SearchController#index] Received search params: #{search_params.inspect}"
    search_service = SearchService.new(search_params, SearchStrategies::StandardSearch)
    results = search_service.perform
    puts "[SearchController#index] Search results: #{results.inspect}"
    render json: { results: results }, status: :ok
  end

  def autocomplete
    puts "[SearchController#autocomplete] Received autocomplete params: #{autocomplete_params.inspect}"
    autocomplete_service = SearchService.new(autocomplete_params, SearchStrategies::AutocompleteSearch)
    suggestions = autocomplete_service.perform
    puts "[SearchController#autocomplete] Autocomplete suggestions: #{suggestions.inspect}"
    render json: { suggestions: suggestions }, status: :ok
  end
  
  private

  def search_params
    params.permit(:query, :team_name_filter, :score_from, :score_to)
  end

  def autocomplete_params
    params.permit(:query)
  end
end
