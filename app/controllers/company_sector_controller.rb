class CompanySectorController < ApplicationController

  def index
    @allSectorViews = SecurityView.select("security_views.id, company_sectors.name as name, count(security_views.id)").joins(:company_sector,:security).includes(:security,:company_sector).group("securities.company_sector_id").order("count(security_id) desc").limit(10)
  end


  def show
    if params[:id].nil?
      @errors = 'Sector Required'
    else
      @sector = CompanySector.where(:id => (params[:id])).first
      #@allSectorViews = SecurityView.select("securities.name as security_name,securities.ticker as security_ticker").where("securities.company_sector_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
      #@allSectorViews = SecurityView.select("security_id,count(security_id)").where("securities.company_sector_id = ?",1).includes(:security).group("security_id").order("count(security_id) desc").limit(10)
      @allSectorViews = SecurityView.select("security_id,count(security_id)").where("securities.company_sector_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
      @todaysSectorViews = SecurityView.select("security_id,count(security_id)").where("securities.company_sector_id = ? and security_views.created_at >= ?",params[:id],Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc")
      @thisWeeksSectorViews = SecurityView.select("security_id,count(security_id)").where("securities.company_sector_id = ? and security_views.created_at >= ?",params[:id],Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc")
      if @sector.nil?
        @errors = 'Sector not found'
      end
    end
  end

end
