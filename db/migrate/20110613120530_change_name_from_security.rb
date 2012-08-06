class ChangeNameFromSecurity < ActiveRecord::Migration
  def self.up
      change_column :securities, :name, :string, :limit => 128
    remove_column :securities, :type
    add_column :securities, :security_type, :string
  end

  def self.down
  end
end
