class CreateReferenceCaches < ActiveRecord::Migration
  def change
    create_table :reference_caches do |t|
      t.string :item_type
      t.integer :item_id
      t.string :site_title
      t.string :site_path
      t.string :item_path

      t.timestamps
    end
  end
end
