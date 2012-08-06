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
end
