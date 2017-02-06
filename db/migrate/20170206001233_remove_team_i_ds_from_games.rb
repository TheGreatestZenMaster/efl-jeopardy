class RemoveTeamIDsFromGames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :team1_id
    remove_column :games, :team2_id
  end
end
