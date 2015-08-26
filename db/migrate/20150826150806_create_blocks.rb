class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :parent_id
      t.integer :page_id
      t.integer :position, :default => 0

      t.timestamps
    end
  end
end
