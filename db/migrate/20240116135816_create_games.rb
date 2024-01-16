class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.text :frames
      t.integer :total_score

      t.timestamps
    end
  end
end
