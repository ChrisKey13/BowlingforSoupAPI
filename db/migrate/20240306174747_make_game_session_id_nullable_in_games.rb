class MakeGameSessionIdNullableInGames < ActiveRecord::Migration[7.1]
  def change
    change_column_null :games, :game_session_id, true
  end
end
