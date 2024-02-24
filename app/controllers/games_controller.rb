class GamesController < ApplicationController
  before_action :set_game, only: [:show, :roll]

  def create
    game = Game.create
    render json: game, status: :created
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

  def roll_params
    params.require(:game).permit(:pins)
  end

  def set_game
    @game = Game.find(params[:id])
  end
end
