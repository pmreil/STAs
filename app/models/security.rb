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

  def ticker_views( num_days = nil )
    if num_days.nil?
      return security_views.count
    else
      return security_views.where("created_at >= '#{Time.now - num_days.days}'").count
    end
  end

  def percentage_views (num_days = nil)
    if num_days.nil?
      total_views = SecurityView.count
      the_ticker_views = ticker_views
    else
      total_views = SecurityView.where("created_at >= '#{Time.now - num_days.days}'").count
      the_ticker_views = ticker_views num_days
    end
    the_ticker_views / total_views.to_f
  end

  

end
