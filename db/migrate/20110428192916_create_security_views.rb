class CreateSecurityViews < ActiveRecord::Migration
  def self.up
    create_table :security_views do |t|
      t.integer :security_id
      t.string :viewer_ip_address
      t.string :viewer_browser_string
      t.timestamps
    end
  end

  def self.down
    drop_table :security_views
  end
end
