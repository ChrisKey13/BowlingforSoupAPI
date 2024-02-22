class GameplayManager

  def initialize(game_context)
    @game_context = game_context
  end

  def handle_roll(pins)
    puts "DEBUG: GameplayManager#handle_roll - Before Processing Roll: Current Frame=#{@game_context.current_frame}, Pins=#{pins}"
    add_roll(pins)
    puts "DEBUG: GameplayManager#handle_roll - After Processing Roll: Current Frame=#{@game_context.current_frame}, Frames=#{@game_context.frames.inspect}"
    update_game_state
    calculate_total_score
  end

  private

  def add_roll(pins)
    RollService.new(@game_context).add_roll(pins)
  end

  def update_game_state
    new_state = GameStateFactory.build_state(@game_context.game)
    @game_context.game.update(state: new_state)

  end

  def calculate_total_score
    GameScorer.new(@game_context).calculate_total_score
  end
end

