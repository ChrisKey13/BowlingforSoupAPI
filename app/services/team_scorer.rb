class TeamScorer
    attr_reader :game_session
  
    def initialize(game_session)
      @game_session = game_session
    end
  
    def call
        scores_by_team
    end
  
    private
  
    def scores_by_team
        @game_session.teams.includes(:players).each_with_object({}) do |team, scores|
            score = total_score_for_team(team)
            scores[team.name] = score
        end
    end      
      
  
    def total_score_for_team(team)
        total_score = team.players
                           .joins(:games)
                           .where(games: { game_session_id: @game_session.id })
                           .sum('games.total_score')
        total_score
      end
      
      
end
  