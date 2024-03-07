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
        puts "Debug Winners: #{@game_session.winners.inspect}"

        puts "Entering the winner method..."

        puts "Entering the winner method..."

        @game_session.reload
        puts "Debugging Controller - Total Games in Session after reload: #{@game_session.games.size}"
        
        games = @game_session.games
        puts "Total Games in Session: #{games.size}"
        games.each_with_index do |game, index|
          puts "Game #{index + 1}: ID: #{game.id}, Player ID: #{game.player_id}, Score: #{game.total_score}"
        end

        if @game_session.players.empty?
            render json: { message: 'No players in this game session.' }, status: :ok
        elsif @game_session.games.empty?
            render json: { message: 'No games in this session' }, status: :ok
        elsif !@game_session.games.where("total_score > 0").exists?  # Updated condition
            render json: { message: 'No games have been played in this session.' }, status: :ok
        else
          winners = @game_session.winners
          puts "Number of winners: #{winners.length}"
          if winners.length > 1
            puts "Rendering tied winners..."
            render json: { winners: winners.map { |w| { id: w.id, name: w.name } } }, status: :ok
          elsif winners.length == 1
            puts "Rendering single winner..."
            render json: { winner: winners.first.name }, status: :ok
          else
            puts "Unexpected scenario."
            render json: { message: 'Unexpected scenario.' }, status: :internal_server_error
          end
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
