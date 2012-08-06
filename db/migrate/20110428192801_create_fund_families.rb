class CreateFundFamilies < ActiveRecord::Migration
  def self.up
    create_table :fund_families do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :fund_families
  end
end
