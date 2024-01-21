class Game < ApplicationRecord
  include BowlingValidation

  serialize :frames, type: Array, coder: YAML

  MAX_PINS = 10
  FRAMES_PER_GAME = 10

  attr_reader :current_roll
  attr_accessor :frame, :total_score, :current_frame, :state, :current_roll_attempt
  
  after_initialize :initialize_state

  
  def roll(pins)
    self.current_roll_attempt = pins
    if valid?
      update_game_state_with_roll(pins)
      true
    else
      false
    end
  end
    
  def rolls
    frames.flatten
  end
    
  def current_roll=(pins)
    @current_roll = pins
  end

  private
    
  def initialize_state
    @frames = []
    @total_score = 0
    @current_frame = 0
    @current_roll = 0
    @state = GameStateFactory.build_state(self)
  end

  def update_game_state_with_roll(pins)
    state.roll(pins)
    self.state = GameStateFactory.build_state(self) 
  end
end
  