class AddMetaToPages < ActiveRecord::Migration
  def change
    add_column :pages, :meta, :json
  end
end
