class GamesController < ApplicationController
  before_action :set_game, only: [:show, :roll]
  before_action :set_game_session, only: [:create, :create_for_player]

  def create
    game = game_session.games.create(game_params.except(:player_id))
  
    if game.persisted?
      render json: game, status: :created
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_for_player
    game = @game_session.games.new(game_params)

    if game.save
      render json: game, status: :created
    else
      render json: game.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: { frames: @game.frames, total_score: @game.total_score }
  end
  
  def roll
    if @game.roll(roll_params[:pins].to_i)
      render json: @game, status: :ok
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:pins, :game_session_id, :player_id)
  end

  def roll_params
    params.require(:game).permit(:pins)
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def set_game_session
    @game_session = GameSession.find(params[:game_session_id])
  end
end
