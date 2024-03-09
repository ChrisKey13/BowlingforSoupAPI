class TeamPlayer < ApplicationRecord
    belongs_to :team
    belongs_to :player

    validates :player_id, uniqueness: { scope: :team_id }
end
