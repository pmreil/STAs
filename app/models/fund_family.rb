# == Schema Information
# Schema version: 20110428192916
#
# Table name: fund_families
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class FundFamily < ActiveRecord::Base
  has_many :securities
  has_many :security_views, :through => :securities

  def self.all_views
    select("fund_families.id,fund_families.name,count(security_views.id)").joins(:security_views).group("fund_families.id").order("count(security_id) desc").limit(10)
  end

end
