module SearchStrategies
    class AutocompleteSearch < BaseStrategy
        protected
  
        def search_definition
            definition = {
                    suggest: {
                        text: sanitized_query,
                        name_suggestion: {
                            prefix: sanitized_query,
                            completion: {
                                field: 'name_suggest',
                                fuzzy: { fuzziness: "AUTO" },
                                skip_duplicates: true
                            }
                        }
                    }
                }
            puts "Search definition: #{definition}"
            definition
        end
  
        private
  
        def sanitized_query
            sanitized = params[:query].strip.gsub(/([+\-=><!(){}\[\]^"~*?:\/]|&&|\|\|)/) { "\\#{Regexp.last_match(0)}" }
            Rails.logger.debug { "Sanitized query: #{sanitized}" }
            puts "[AutocompleteSearch#search_definition] Definition: #{sanitized.inspect}"
            sanitized
        end
          
  
        def search_models
            [Player, Team]
        end
    end
end
  