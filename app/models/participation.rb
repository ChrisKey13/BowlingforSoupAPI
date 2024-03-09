class Participation < ApplicationRecord
    belongs_to :team
    belongs_to :game_session

    validates :team_id, uniqueness: { scope: :game_session_id } 
end