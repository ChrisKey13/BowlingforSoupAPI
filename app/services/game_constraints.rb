require 'singleton'

class GameConstraints
    include Singleton

    MAX_PINS = 10
    FRAMES_PER_GAME = 10
    REGULAR_MAX_ROLLS = 2
    FINAL_MAX_ROLLS = 3

    def max_pins
        MAX_PINS
    end

    def frames_per_game
        FRAMES_PER_GAME
    end

    def final_max_rolls
        FINAL_MAX_ROLLS
    end

    def regular_max_rolls
        REGULAR_MAX_ROLLS
    end
end