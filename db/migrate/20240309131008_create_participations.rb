class CreateParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :participations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :game_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
