class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.string :label
      t.integer :list_id

      t.timestamps
    end
  end
end
