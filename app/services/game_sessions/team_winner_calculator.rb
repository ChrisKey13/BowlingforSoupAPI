module GameSessions
    class TeamWinnerCalculator < WinnerCalculator
        def calculate
            winning_teams = @game_session.winning_teams
            if winning_teams.any?
              serialized_teams = ActiveModelSerializers::SerializableResource.new(winning_teams, each_serializer: TeamSerializer).as_json
              { team_winners: serialized_teams }
            else
              { error: "No winning team found" }
            end
          rescue => e
            puts "Error calculating winner: #{e.message}\n#{e.backtrace.join("\n")}"
            { error: "Failed to calculate winner" }
          end
    end
end