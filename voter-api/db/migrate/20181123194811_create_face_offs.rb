class CreateFaceOffs < ActiveRecord::Migration[5.2]
  def change
    create_table :face_offs do |t|
      t.integer :loser_id
      t.integer :user_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
