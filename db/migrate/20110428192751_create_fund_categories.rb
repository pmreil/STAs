class CreateFundCategories < ActiveRecord::Migration
  def self.up
    create_table :fund_categories do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :fund_categories
  end
end
