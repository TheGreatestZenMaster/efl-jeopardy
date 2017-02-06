class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.boolean :is_active, :default => false
      t.references :team1, references: :team
      t.references :team2, references: :team
      t.timestamps
    end
  end
end
