class Participation < ApplicationRecord
    include Searchable

    belongs_to :team
    belongs_to :game_session

    validates :team_id, uniqueness: { scope: :game_session_id } 

    def as_indexed_json(options={})
        super.merge({
            model_type: self.class.name.downcase,
            team_id: team_id,
            game_session_id: game_session_id
        })
    end
end