class RenameGeoColumns < ActiveRecord::Migration
  def up
    rename_column :security_views, :county, :country
  end

  def down
  end
end
