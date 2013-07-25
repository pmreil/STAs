class FundFamilyController < ApplicationController

  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Fund Family ID Required'
    else
      @family = FundFamily.where(:id => (params[:id])).first
      if @family.nil?
        @errors = 'Fund family not found'
      else
        @allFamilyViews = SecurityView.select("security_id,count(security_id)").where("securities.fund_family_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
        @todaysFamilyViews = SecurityView.select("security_id,count(security_id)").where("securities.fund_family_id = ? and security_views.created_at >= ?",params[:id],Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)
        @thisWeeksFamilyViews = SecurityView.select("security_id,count(security_id)").where("securities.fund_family_id = ? and security_views.created_at >= ?",params[:id],Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)        
      end
    end
  end

end
