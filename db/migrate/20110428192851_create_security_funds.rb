class CreateSecurityFunds < ActiveRecord::Migration
  def self.up
    create_table :security_funds do |t|
      t.integer :fund_category_id
      t.integer :fund_family_id
      t.timestamps
    end
  end

  def self.down
    drop_table :security_funds
  end
end
