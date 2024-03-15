module GameSessions
    class WinnerCalculator
        def initialize(game_session)
            @game_session = game_session
        end
    
        def self.for(game_session)
            if game_session.teams.any?
                GameSessions::TeamWinnerCalculator.new(game_session)
            else
                GameSessions::IndividualWinnerCalculator.new(game_session)
            end
        end
    
        def calculate
            raise NotImplementedError
        end
    end    
end