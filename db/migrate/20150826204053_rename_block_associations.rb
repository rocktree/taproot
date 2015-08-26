class RenameBlockAssociations < ActiveRecord::Migration
  def change
    rename_column :blocks, :parent_id, :block_id
  end
end
