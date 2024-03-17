class TeamPlayer < ApplicationRecord
    include Searchable

    belongs_to :team
    belongs_to :player

    validates :player_id, uniqueness: { scope: :team_id }

    def as_indexed_json(options={})
        super.merge({
            model_type: self.class.name.downcase,
            team_id: team_id,
            player_id: player_id
        })
    end
end
