class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :key
      t.string :secret

      t.timestamps
    end
  end
end
