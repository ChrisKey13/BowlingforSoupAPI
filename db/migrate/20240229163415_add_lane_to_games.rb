class AddLaneToGames < ActiveRecord::Migration[7.1]
  def change
    add_reference :games, :lane, null: false, foreign_key: true
  end
end
