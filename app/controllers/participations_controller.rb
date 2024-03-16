class ParticipationsController < ApplicationController
    def create
        participation = Participation.new(participation_params)

        if participation.save
            render json: participation, status: :created
        else
            render json: participation.errors, status: :unprocessable_entity
        end
    end

    private

    def participation_params
        params.require(:participation).permit(:team_id, :game_session_id)
    end
end