class AddUniqueIndexToParticipations < ActiveRecord::Migration[7.1]
  def change
    add_index :participations, [:team_id, :game_session_id], unique: true
  end
end
