class GameStateFactory
  extend FrameCompleteness

  def self.build_state(game)
    if game_over?(game)
      GameOverState.new(game)
    elsif final_frame?(game)
      final_frame_complete?(game) ? GameOverState.new(game) : FinalFrameState.new(game)
    else
      RegularFrameState.new(game)
    end
  end
  
  def self.game_over?(game)
    final_frame_complete?(game) && game.current_frame > GameConstraints.instance.frames_per_game
  end

  def self.final_frame?(game)
    game.current_frame ==  GameConstraints.instance.frames_per_game
  end
end
