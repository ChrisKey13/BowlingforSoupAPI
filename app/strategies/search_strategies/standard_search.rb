module SearchStrategies
    class StandardSearch < BaseStrategy
        def execute
            puts "[StandardSearch#execute] Executing search with definition: #{search_definition.inspect}"
            super
        end
        
        private
  
        def search_fields
            ['name^2']
        end
  
        def filters
            []
        end
         
    end
end
  