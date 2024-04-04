module SearchStrategies
    class BaseStrategy
        attr_reader :params
  
        def initialize(params)
            @params = params
        end
  
        def execute
            query = search_definition
            puts "[BaseStrategy#execute] Sending query to Elasticsearch: #{query.inspect}"
            response = Elasticsearch::Model.search(query, search_models)
            raw_response = response.response
            puts "[BaseStrategy#execute] Raw Elasticsearch response: #{raw_response.inspect}"
            response
        end
  
        protected
  
        def search_definition
            {
                query: build_query,
                highlight: { fields: { name: {} } }
            }
        end
  
        def build_query
            {
                bool: {
                    must: must_query,
                    filter: filters
                }
            }
        end
  
        def must_query
            {
                multi_match: {
                    query: params[:query].strip,
                    fields: search_fields,
                    fuzziness: "AUTO"
                }
            }
        end
  
        def filters
            SearchComponents::Filters.build(params)
        end
  
        def search_models
            [GameSession, Game, Participation, Player, TeamPlayer, Team]
        end
  
        def search_fields
            ['name^2', 'description', 'model_type']
        end
    end
end
  