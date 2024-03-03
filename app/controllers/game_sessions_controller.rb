class GameSessionsController < ApplicationController

    def show
        
    end

    def create
        puts "Received params: #{game_sessions_params.inspect}"
        game_session = GameSession.new(game_sessions_params)
        if game_session.save
            puts "GameSession created successfully: #{game_session.inspect}"
            render json: game_session, include: :players, status: :created
        else
            puts "Failed to create GameSession: #{game_session.errors.full_messages}"
            render json: game_session.errors, status: :unprocessable_entity
        end
    end

    private

    def game_sessions_params
        params.require(:game_session).permit(players_attributes: [:name])
    end
end
