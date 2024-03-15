class TeamSerializer < ActiveModel::Serializer
    attributes :id, :name, :total_score
  
    has_many :players, serializer: PlayerSerializer
  
    def total_score
        object.players.includes(:games).sum { |player| player.games.sum(:total_score) }
    end
end