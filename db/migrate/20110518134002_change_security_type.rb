class ChangeSecurityType < ActiveRecord::Migration
  def self.up
    remove_column :securities, :instrument_id
    remove_column :securities, :instrument_type
    add_column :securities, :type, :string
  end

  def self.down
    add_column :securities, :instrument_id, :integer
    add_column :securities, :instrument_type, :string
    remove_column :securities, :type
  end
end
