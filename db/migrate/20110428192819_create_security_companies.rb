class CreateSecurityCompanies < ActiveRecord::Migration
  def self.up
    create_table :security_companies do |t|
      t.integer :company_industry_id
      t.integer :company_sector_id
      t.timestamps
    end
  end

  def self.down
    drop_table :security_companies
  end
end
