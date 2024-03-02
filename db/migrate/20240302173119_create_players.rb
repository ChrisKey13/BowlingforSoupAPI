class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.references :game_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
