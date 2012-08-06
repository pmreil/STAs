class Simplify < ActiveRecord::Migration
  def self.up
    #drop_table :companies
    #drop_table :funds
    add_column :securities, :fund_category_id, :integer
    add_column :securities, :fund_family_id, :integer
    add_column :securities, :company_industry_id, :integer
    add_column :securities, :company_sector_id, :integer
  end

  def self.down
  end
end
