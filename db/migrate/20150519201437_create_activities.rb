class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :item_type
      t.integer :item_id
      t.string :item_path
      t.integer :site_id
      t.integer :user_id
      t.string :action

      t.timestamps
    end
  end

end
