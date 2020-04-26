class AddMetaColumnsToVersions < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :taxonomies, :json
  end
end
