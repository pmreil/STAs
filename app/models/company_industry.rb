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

  def to_param 
    name
  end

  def top_industries( num_days = nil )
    if num_days.nil?
      return security_views.count
    else
      return security_views.where("created_at >= '#{Time.now - num_days.days}'").count
    end
  end

end