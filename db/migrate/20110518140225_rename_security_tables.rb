class RenameSecurityTables < ActiveRecord::Migration
  def self.up
    rename_table :security_companies, :companies
    rename_table :security_funds, :funds
  end

  def self.down
    rename_table :companies, :security_companies
    rename_table :funds, :security_funds
  end
end
