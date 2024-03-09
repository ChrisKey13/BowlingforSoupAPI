class AddUniqueIndexToTeamPlayers < ActiveRecord::Migration[7.1]
  def change
    add_index :team_players, [:team_id, :player_id], unique: true
  end
end
