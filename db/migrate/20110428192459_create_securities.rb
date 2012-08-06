class CreateSecurities < ActiveRecord::Migration
  def self.up
    create_table :securities do |t|
      t.string :ticker, :null => false
      t.string :name, :null => false
      t.integer :type_id, :null => false
      t.integer :exchange_id, :null => false
      t.integer :views, :default => 0	   
      t.timestamps
    end
  end

  def self.down
    drop_table :securities
  end
end
