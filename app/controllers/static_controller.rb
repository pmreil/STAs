class StaticController < ApplicationController
  def home
	@allSecurityViews = SecurityView.select("security_id, count(security_id) as views").includes(:security).group("security_id").order("views desc")
	@allSectorViews = SecurityView.select("company_sectors.name, company_sectors.id, count(company_sectors.id) as views").joins(:security, :company_sector).group("company_sectors.id").order("views desc")
  @allIndustryViews = SecurityView.select("company_industries.name, company_industries.id, count(company_industries.id) as views").joins(:security, :company_industry).group("company_industries.id").order("views desc")
  end

  def about
  end

  def contact
  end

  def terms_conditions
  end

end
