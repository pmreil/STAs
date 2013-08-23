# == Schema Information
# Schema version: 20110518183629
#
# Table name: securities
#
#  id                  :integer(4)      not null, primary key
#  ticker              :string(255)     not null
#  name                :string(255)     not null
#  exchange_id         :integer(4)      not null
#  created_at          :datetime
#  updated_at          :datetime
#  type                :string(255)
#  fund_category_id    :integer(4)
#  fund_family_id      :integer(4)
#  company_industry_id :integer(4)
#  company_sector_id   :integer(4)
#

# information 

class Security < ActiveRecord::Base
  has_many :security_views
  belongs_to :security_exchange, :foreign_key => "exchange_id"
  belongs_to :fund_family
  belongs_to :fund_category
  belongs_to :company_industry
  belongs_to :company_sector

  def to_param 
    ticker
  end
  
  def ticker_views( num_weeks_back = nil )
    if num_weeks_back.nil?
      return self.security_views.count
    else
      return self.security_views.where("created_at >= '#{Time.now - (7*num_weeks_back).days}' and created_at <= '#{Time.now - (7*(num_weeks_back-1)).days}'").count
    end
  end

  def percentage_weekly_views (num_weeks_back = nil)
    if num_weeks_back.nil?
      total_views = SecurityView.count
      the_ticker_views = ticker_views
    else
      total_views = SecurityView.where("created_at >= '#{Time.now - (7*num_weeks_back).days}' and created_at <= '#{Time.now - (7*(num_weeks_back-1)).days}'").count
      the_ticker_views = ticker_views num_weeks_back
    end
    if the_ticker_views == 0
      return 0
    end
    the_ticker_views.to_f / total_views.to_f * 100
  end

  

end
