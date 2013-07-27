# == Schema Information
# Schema version: 20110428192916
#
# Table name: company_industries
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class CompanyIndustry < ActiveRecord::Base
  has_many :securities
  has_many :security_views, through: :securities

  def self.all_views
    select("company_industries.id,company_industries.name,count(security_views.id)").joins(:security_views).group("company_industries.id").order("count(security_id) desc").limit(10)
  end

end