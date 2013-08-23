class StaticController < ApplicationController
  def home
    @allSecurityViews = SecurityView.select("security_id, count(security_id) as views").where("security_views.created_at >= ?",Time.now-7.day).includes(:security).group("security_id").order("views desc").limit(12)
    @allSectorViews = SecurityView.select("company_sectors.name, company_sectors.id, count(company_sectors.id) as views").where("security_views.created_at >= ?",Time.now-7.day).joins(:security, :company_sector).group("company_sectors.id").order("views desc").limit(5)
    @allIndustryViews = SecurityView.select("company_industries.name, company_industries.id, count(company_industries.id) as views").where("security_views.created_at >= ?",Time.now-7.day).joins(:security, :company_industry).group("company_industries.id").order("views desc").limit(5)
    @allFundCategoryViews = SecurityView.select("fund_categories.name, fund_categories.id, count(fund_categories.id) as views").where("security_views.created_at >= ?",Time.now-7.day).joins(:security, :fund_category).group("fund_categories.id").order("views desc").limit(5)
    @lastTenSecurityViews = SecurityView.includes(:security).order("id desc").limit(10)
  end

  def about
  end

  def contact
  end

  def terms_conditions
  end

end
