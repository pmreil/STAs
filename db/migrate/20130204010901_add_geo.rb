class AddGeo < ActiveRecord::Migration
  def up
  	change_table :security_views do |t|
  		t.string :city
  		t.string :state
  		t.string :zip
  		t.string :county
  		t.float :lat
  		t.float :lng
		end
  end

  def down
  end
end
