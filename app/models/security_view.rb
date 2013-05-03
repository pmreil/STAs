# == Schema Information
# Schema version: 20110428192916
#
# Table name: security_views
#
#  id                    :integer(4)      not null, primary key
#  security_id           :integer(4)
#  viewer_ip_address     :string(255)
#  viewer_browser_string :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class SecurityView < ActiveRecord::Base
  belongs_to :security
  has_one :company_sector, through => :security
  has_one :company_industry, through => :security
  has_one :fund_category, through => :security
end
