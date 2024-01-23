class GameStateFactory
  extend FrameCompleteness

  def self.build_state(game)
    return GameOverState.new(game) if game_over?(game)
    return FinalFrameState.new(game) if final_frame?(game)

    RegularFrameState.new(game)
  end
  
  def self.game_over?(game)
    game.current_frame > GameConstraints.instance.frames_per_game
  end

  def self.final_frame?(game)
    game.current_frame ==  GameConstraints.instance.frames_per_game
  end
end
