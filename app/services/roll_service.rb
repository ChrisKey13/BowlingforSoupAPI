class RollService
    include FrameCompleteness

    def initialize(game_context)
        @game_context = game_context
        @game = game_context.game
    end

    def add_roll(pins)

        puts "DEBUG: RollService#add_roll - Start: Current Frame=#{@game.current_frame}, Pins=#{pins}, Frames before=#{@game.frames.inspect}"
        if final_frame?
            handle_final_frame_rolls(pins)
        else
            puts "DEBUG: RollService#add_roll - Before Update: Current Frame=#{@game.current_frame}, Frames=#{@game.frames.inspect}"
            update_frames(pins)
            puts "DEBUG: RollService#add_roll - Before Update: Current Frame=#{@game.current_frame}, Frames=#{@game.frames.inspect}"
            update_counts
            puts "DEBUG: RollService#add_roll - After update_counts: Current Frame=#{@game.current_frame}, Current Roll=#{@game.current_roll}"
            update_game_state_if_needed
        end
        puts "DEBUG: RollService#add_roll - After update: Frames=#{@game.frames.inspect}, Current Frame=#{@game.current_frame}, Current Roll=#{@game.current_roll}"
    end

    private

    def update_frames(pins)
        puts "DEBUG: update_frames - Before: Frames=#{@game.frames.inspect}"
        if new_frame_needed?
            @game.frames << [pins]
        else
            @game.frames.last << pins
        end
        puts "DEBUG: update_frames - After: Frames=#{@game.frames.inspect}"
    end
      
    def update_counts
        puts "DEBUG: update_counts - Before: Current Frame=#{@game.current_frame}, Current Roll=#{@game.current_roll}"
        if frame_complete?(@game, @game.frames.last, is_final_frame: final_frame?)
            advance_frame
        else
            increment_roll
        end
        puts "DEBUG: update_counts - After: Current Frame=#{@game.current_frame}, Current Roll=#{@game.current_roll}"
    end
      
    def advance_frame
        puts "DEBUG: RollService#advance_frame - Advancing to Next Frame: Next Frame=#{@game.current_frame + 1}"
        unless final_frame?
            @game.current_frame += 1
            @game.current_roll = 0
        end
    end
      
    def increment_roll
        puts "DEBUG: RollService#increment_roll - Incrementing Roll Count: Next Roll=#{@game.current_roll + 1}"
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

    def handle_final_frame_rolls(pins)
        @game.frames.last << pins if @game.frames.last.length < 3
    end
end
