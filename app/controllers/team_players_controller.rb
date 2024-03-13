class TeamPlayersController < ApplicationController
    before_action :set_team
  
    def create
      player = Player.find_by(id: team_player_params[:player_id])
      unless player
        return render json: { error: "Player not found" }, status: :not_found
      end
  
      if @team.players << player
        render json: { message: "Player added to team successfully" }, status: :created
      else
        render json: { error: "Player could not be added to the team" }, status: :unprocessable_entity
      end
    end
  
    def update
      player_ids = params.dig(:team, :player_ids)&.reject(&:blank?)&.map(&:to_i)
      @team.player_ids = player_ids
  
      render json: @team, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  
    def destroy
      team_player = @team.team_players.find_by(id: params[:id])
      if team_player
        team_player.destroy
        render json: { message: "Player removed from team successfully" }, status: :ok
      else
        render json: { error: "Player not found in this team or does not exist" }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_team
      @team = Team.find(params[:team_id])
    end
  
    def team_player_params
      params.require(:team_player).permit(:player_id)
    end
  end
  