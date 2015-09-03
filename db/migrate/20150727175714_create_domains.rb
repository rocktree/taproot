class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :title
      t.integer :site_id
      t.integer :redirect_id

      t.timestamps
    end
  end
end
