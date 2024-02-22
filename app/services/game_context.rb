class GameContext
    attr_reader :game

    def initialize(game)
        @game = game       
    end

    def current_frame
        game.current_frame
    end

    def total_score
        game.total_score
    end

    def update_total_score(new_score)
        game.total_score = new_score
        game.save        
    end

    def state
        game.state
      end
    
      def state=(new_state)
        game.state = new_state
      end

    def frames
        game.frames
    end

end