class AddPlayerRefToGames < ActiveRecord::Migration[7.1]
  def change
    add_reference :games, :player, null: true, foreign_key: true
  end
end
