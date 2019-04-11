class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :user_id
      t.integer :score
      t.string :word
      t.string :definition

      t.timestamps
    end
  end
end
