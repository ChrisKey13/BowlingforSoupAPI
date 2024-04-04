class SearchService
    attr_reader :params, :strategy
  
    def initialize(params, strategy_class)
        @params = params
        @strategy = strategy_class.new(params)
        puts "[SearchService] Initialized with params: #{params.inspect} and strategy: #{strategy.class}"
    end
  
    def perform
        cache_key = build_cache_key
        puts "[SearchService] Fetching or storing with cache key: #{cache_key}"
        SearchCacheManager.fetch_or_store(cache_key) do
            response = @strategy.execute
            puts "[SearchService] Strategy execution response: #{response.inspect}"
            if strategy.is_a?(SearchStrategies::AutocompleteSearch)
                suggestions = extract_suggestions(response)
                puts "[SearchService] Extracted autocomplete suggestions: #{suggestions.inspect}"
                suggestions
            else
                response
            end
        end
    end
  
    private
  
    def build_cache_key
        "#{strategy_key}:#{params.to_json}"
    end
  
    def strategy_key
        strategy.class.name.demodulize.underscore
    end
  
    def extract_suggestions(response)
        suggestions = response.response['suggest']['name_suggestion'][0]['options'].map do |option|
            { text: option['text'], score: option['_score'] }
        end
        puts "[SearchService#extract_suggestions] Extracted suggestions: #{suggestions.inspect}"
        suggestions
    end
end
  