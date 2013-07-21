class CompanySectorController < ApplicationController

  def index
    @allSectorViews = SecurityView.select("company_sectors.name as name, count(security_views.id)").joins(:company_sector,:security).includes(:security,:company_sector).group("securities.company_sector_id,security_views.id").order("count(security_id) desc").limit(10)
    #@todaysSectorViews = SecurityView.where("securities.company_sector_id = ? and security_views.created_at >= ?",1,Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc")
    #@thisWeeksSectorViews = SecurityView.where("securities.company_sector_id = ? and security_views.created_at >= ?",1,Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc")
  end


  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Sector Required'
    else
      @sector = CompanySector.where(:id => (params[:id])).first
      @allSectorViews = SecurityView.where("securities.company_sector_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
      @todaysSectorViews = SecurityView.where("securities.company_sector_id = ? and security_views.created_at >= ?",params[:id],Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc")
      @thisWeeksSectorViews = SecurityView.where("securities.company_sector_id = ? and security_views.created_at >= ?",params[:id],Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc")
      if @sector.nil?
        @errors = 'Sector not found'
      end
    end
  end

end
