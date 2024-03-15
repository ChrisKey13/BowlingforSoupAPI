module GameSessions
    class IndividualWinnerCalculator < WinnerCalculator
        def calculate
            winners = @game_session.winners
            format_individual_winners(winners)
        end
    
        private
        
        def format_individual_winners(winners)
            if winners.length > 1
                { winners: winners.map { |w| { id: w.id, name: w.name } } }
            elsif winners.length == 1
                { winner: winners.first.name }
            else
                { message:'Unexpected scenario.' }
            end
        end 
    end
end