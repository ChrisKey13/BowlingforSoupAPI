class GameScorer
    def initialize(game)
      @game = game
    end
  
    def calculate
        total_score = 0
        rolls = @game.rolls.to_a
    
        frame_index = 0
        10.times do
          if strike?(rolls[frame_index])
            total_score += 10 + strike_bonus(rolls, frame_index)
            frame_index += 1
          elsif spare?(rolls[frame_index], rolls[frame_index + 1])
            total_score += 10 + spare_bonus(rolls[frame_index + 2])
            frame_index += 2
          else
            total_score += (rolls[frame_index] || 0) + (rolls[frame_index + 1] || 0)
            frame_index += 2
          end
        end
    
        total_score
      end
    
      private
    
      def strike?(roll)
        roll == 10
      end
    
      def spare?(roll1, roll2)
        roll2 && roll1 + roll2 == 10
      end
    
      def strike_bonus(rolls, frame_index)
        rolls[frame_index + 1] + (rolls[frame_index + 2] || 0)
      end
    
      def spare_bonus(next_roll)
        next_roll
      end
    end
  