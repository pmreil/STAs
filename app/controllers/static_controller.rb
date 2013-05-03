class StaticController < ApplicationController
  def home
	@allViews = SecurityView.select("security_id, count(security_id) as views").includes(:security).group("security_id").order("views desc")
  end

  def about
  end

  def contact
  end

  def terms_conditions
  end

end
