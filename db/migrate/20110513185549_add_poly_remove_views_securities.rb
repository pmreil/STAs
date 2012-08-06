class AddPolyRemoveViewsSecurities < ActiveRecord::Migration
  def self.up
    add_column :securities, :instrument_id, :integer
    add_column :securities, :instrument_type, :string
    remove_column :securities, :type_id
    remove_column :securities, :views
  end

  def self.down
    remove_column :securities, :instrument_id
    remove_column :securities, :instrument_type
  end
end
