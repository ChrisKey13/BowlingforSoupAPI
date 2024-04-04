module SearchComponents
    class Filters
        def self.build(params)
            [].tap do |filters|
                filters << team_name_filter(params[:team_name_filter])
                filters << score_range_filter(params[:score_from], params[:score_to])
                filters.compact!
            end
        end
  
        def self.team_name_filter(team_name)
            { term: { 'team_name.keyword': team_name } } if team_name.present?
        end
  
        def self.score_range_filter(from, to)
            return unless from.present? || to.present?
  
            {
            range: {
                score: {
                gte: from,
                lte: to
                }.compact
            }
            }
        end
    end
end
  