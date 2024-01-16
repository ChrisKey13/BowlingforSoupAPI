class GamesController < ApplicationController
  def create
    game = Game.create
    render json: game, status: :created
  end

  def roll
    game = Game.find(params[:id])
    puts "Params: #{params.inspect}"  # Print the params to check their values
    if game.roll(roll_params[:pins].to_i)
      render json: game, status: :ok
    else
      render json: { errors: game.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  
  def show
    game = Game.find(params[:id])
    render json: { frames: game.frames, total_score: game.total_score }
  end

  private

  def roll_params
    params.require(:game).permit(:pins)
  end
end
