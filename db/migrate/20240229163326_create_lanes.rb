class CreateLanes < ActiveRecord::Migration[7.1]
  def change
    create_table :lanes do |t|
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
