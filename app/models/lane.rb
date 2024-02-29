class Lane < ApplicationRecord
    has_one :current_game, -> { where(status: 'active') }, class_name: 'Game'
end
