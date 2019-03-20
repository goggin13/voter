class AddListIdToFaceOffs < ActiveRecord::Migration[5.2]
  def change
    add_column :face_offs, :list_id, :integer
  end
end
