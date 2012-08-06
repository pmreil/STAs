class CreateSecurityExchanges < ActiveRecord::Migration
  def self.up
    create_table :security_exchanges do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :security_exchanges
  end
end
