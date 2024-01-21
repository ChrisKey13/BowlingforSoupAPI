require 'singleton'

class GameConstraints
    include Singleton

    MAX_PINS = 10
    FRAMES_PER_GAME = 10

    def max_pins
        MAX_PINS
    end

    def frames_per_game
        FRAMES_PER_GAME
    end
end