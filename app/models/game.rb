class Game < ApplicationRecord
  include BowlingValidation
  belongs_to :player, optional: true

  serialize :frames, type: Array, coder: YAML
  
  attr_accessor :current_frame, :state, :total_score,:current_roll_attempt, :current_roll
  
  after_initialize :initialize_state

  
  def roll(pins)
    return false unless update_roll_attempt(pins) && valid?

    game_context = GameContext.new(self)
    gameplay_manager = GameplayManager.new(game_context)
    gameplay_manager.handle_roll(pins)

    save_context_changes(game_context)
    true
  end

  def rolls
    frames.flatten
  end

  def add_validation_error(message)
    errors.add(:base, message)
  end


  private
    
  def initialize_state
    puts "Initializing state for Game"
    self.frames ||= []
    self.total_score = 0
    self.current_frame = 0
    self.current_roll_attempt ||=0
    self.current_roll ||=0
    self.state = determine_state
  end

  def update_roll_attempt(pins)
    self.current_roll_attempt = pins
    true
  end

  def save_context_changes(game_context)
    assign_attributes_from_context(game_context)
    self.state = determine_state
    save
  end

  def assign_attributes_from_context(game_context)
    self.total_score = game_context.total_score
    self.current_frame = game_context.current_frame
    self.frames = game_context.frames
    self.state = game_context.state
  end

  def determine_state
    GameStateFactory.build_state(self)
  end

end
  