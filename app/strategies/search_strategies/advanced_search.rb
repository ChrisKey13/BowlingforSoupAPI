module SearchStrategies
    class AdvancedSearch < BaseStrategy
        private
  
        def search_fields
            super + ['custom_score']
        end
  
        def advanced_filters
            super.concat([{ range: { 'custom_score': { gte: 50 } } }])
        end
    end
end
  