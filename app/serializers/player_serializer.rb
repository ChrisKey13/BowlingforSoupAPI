class PlayerSerializer < ActiveModel::Serializer
    attributes :id, :name, :score

    def score
        object.games.sum(&:total_score)   
    end
end