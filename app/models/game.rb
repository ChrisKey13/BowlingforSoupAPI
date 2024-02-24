class Game < ApplicationRecord
  include BowlingValidation

  serialize :frames, type: Array, coder: YAML
  
  attr_accessor :current_frame, :state, :total_score,:current_roll_attempt, :current_roll
  
  after_initialize :initialize_state

  
  def roll(pins)
    puts "DEBUG: Before adding roll - Current Frame=#{current_frame}, Pins=#{pins}, Frames=#{frames.inspect}"
    return false unless update_roll_attempt(pins) && valid?
    puts "DEBUG: Game#roll - Validation passed. Proceeding with roll. Current Frame=#{current_frame}, Frames=#{frames.inspect}, Valid=#{valid?}"

    game_context = GameContext.new(self)
    gameplay_manager = GameplayManager.new(game_context)
    gameplay_manager.handle_roll(pins)
    puts "DEBUG: Game#roll - Roll handled. Just before save_context_changes. Current Frame=#{current_frame}, Frames=#{frames.inspect}, Total Score=#{total_score}"

    save_context_changes(game_context)
    puts "DEBUG: After adding roll - Current Frame=#{current_frame}, Frames=#{frames.inspect}"
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
    self.frames ||= []
    self.total_score = 0
    self.current_frame = 0
    self.current_roll_attempt ||=0
    self.current_roll ||=0
    self.state = determine_initial_state
  end

  def update_roll_attempt(pins)
    self.current_roll_attempt = pins
    true
  end

  def save_context_changes(game_context)
    assign_attributes_from_context(game_context)
    self.state = GameStateFactory.build_state(self) 
    save
  end

  def assign_attributes_from_context(game_context)
    self.total_score = game_context.total_score
    self.current_frame = game_context.current_frame
    self.frames = game_context.frames
    self.state = game_context.state
  end

  def determine_initial_state
    GameStateFactory.build_state(self)
  end
end
  