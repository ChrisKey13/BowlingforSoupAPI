class GameSessionsController < ApplicationController
    before_action :set_game_session, only: [:show, :winner]

    def show
        render json: @game_session
    end

    def create
        game_session = GameSession.new(game_sessions_params)
        if game_session.save
            render json: game_session, include: :players, status: :created
        else
            render json: game_session.errors, status: :unprocessable_entity
        end
    end

    def winner
        winner = @game_session.winner
        if winner
            render json: winner
        else
            render json: { error: "Winner could not be determinde"}, status: :unprocessable_entity
        end
    end

    private

    def game_sessions_params
        params.require(:game_session).permit(players_attributes: [:name])
    end

    def set_game_session
        @game_session = GameSession.find(params[:id])
    end
end
