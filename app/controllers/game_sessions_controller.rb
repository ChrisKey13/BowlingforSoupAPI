class GameSessionsController < ApplicationController
    before_action :set_game_session, only: [:show, :winner]

    def show
        if @game_session.teams.any?
          team_scores = TeamScorer.new(@game_session).call
          render json: { game_session: @game_session, teams: team_scores }, include: [:players]
        else
          render json: @game_session, include: [:players, :games]
        end
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
        @game_session.reload        
        games = @game_session.games

        if @game_session.players.empty?
            render json: { message: 'No players in this game session.' }, status: :ok
        elsif @game_session.games.empty?
            render json: { message: 'No games in this session' }, status: :ok
        elsif !@game_session.games.where("total_score > 0").exists? 
            render json: { message: 'No games have been played in this session.' }, status: :ok
        else
          winners = @game_session.winners
          if winners.length > 1
            render json: { winners: winners.map { |w| { id: w.id, name: w.name } } }, status: :ok
          elsif winners.length == 1
            render json: { winner: winners.first.name }, status: :ok
          else
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

    def calculate_team_score(team)
        team.players.joins(:game).sum(:total_score)
    end
end