class StateManager
  include FrameCompleteness

  def initialize(game)
    @game = game
  end

  def transition_to_next_state
    @game.state = determine_next_state
  end

  private

  def determine_next_state
    if game_over?
      GameOverState.new(@game)
    elsif final_frame?
      FinalFrameState.new(@game)
    else
      RegularFrameState.new(@game)
    end
  end

  def game_over?
    final_frame_complete?(@game) && @game.current_frame > Game::FRAMES_PER_GAME
  end

  def final_frame?
    @game.current_frame == Game::FRAMES_PER_GAME
  end
end
