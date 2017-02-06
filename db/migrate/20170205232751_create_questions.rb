class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :points
      t.string :image
      t.references :game, references: :game
      t.boolean :answered, :default => false
      t.integer :grade
      t.timestamps
    end
  end
end
