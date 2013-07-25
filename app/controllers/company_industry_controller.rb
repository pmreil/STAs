class CompanyIndustryController < ApplicationController

  def index
    @allIndustryViews = SecurityView.select("company_industry.name as name, count(security_views.id)").joins(:company_industry).joins(:security).includes(:security,:company_industry).group("securities.company_industry_id").order("count(security_id) desc").limit(10)
  end


  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Industry Required'
    else
      @industry = CompanyIndustry.where(:id => (params[:id])).first
      if @industry.nil?
        @errors = 'Sector not found'
      else
        @allIndustryViews = SecurityView.where("securities.company_industry_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
        @todaysIndustryViews = SecurityView.where("securities.company_industry_id = ? and security_views.created_at >= ?",params[:id],Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)
        @thisWeeksIndustryViews = SecurityView.where("securities.company_industry_id = ? and security_views.created_at >= ?",params[:id],Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)  
      end
    end
  end
end
