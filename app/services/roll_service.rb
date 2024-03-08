class RollService
    include FrameCompleteness

    def initialize(game_context)
        @game_context = game_context
        @game = game_context.game
    end

    def add_roll(pins)
        if pins < 0 || pins > 10
            raise StandardError, "Invalid number of pins: #{pins}"
        end
        begin
            update_roll_data(pins)
        rescue StandardError => exception
            @game.add_validation_error(exception.message)
            return false
        ensure
            update_game_state_if_needed
        end
    end

    private

    def update_roll_data(pins)
        if final_frame?
            @game.frames.last << pins
        else
            update_frames_and_counts(pins)
        end
    end

    def update_frames_and_counts(pins)
        update_frames(pins)
        validate_frame_data
        update_counts
    end

    def update_frames(pins)
        if new_frame_needed?
            @game.frames << [pins]
        else
            @game.frames.last << pins
        end
    end
      
    def update_counts        
        if frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
            advance_frame
        else
            increment_roll
        end
    end
    

    def validate_frame_data
        current_frame_rolls = @game.frames.last || []
        frame_sum = current_frame_rolls.sum
        if !final_frame? && frame_sum > GameConstraints.instance.max_pins
            raise StandardError.new("Validation error - Frame total exceeds maximum pins.")
        end
    end
      
    def advance_frame
        unless final_frame?
            @game.current_frame += 1
            @game.current_roll = 0
        end
    end
      
    def increment_roll
        @game.current_roll += 1
    end
    
    def new_frame_needed?
        @game.frames.empty? || frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
    end
      
    def final_frame?
        @game.current_frame >= GameConstraints.instance.frames_per_game
    end

    def update_game_state_if_needed
        if frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
            new_state = GameStateFactory.build_state(@game)
            @game.state = new_state
        end
    end
end
