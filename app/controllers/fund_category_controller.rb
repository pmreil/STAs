class FundCategoryController < ApplicationController

  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Fund Category ID Required'
    else
      @category = FundCategory.where(:id => (params[:id])).first
      @allCategoryViews = SecurityView.select("security_id,count(security_id)").where("securities.fund_category_id = ?",params[:id]).joins(:security).group("security_id").order("count(security_id) desc").limit(10)
      @todaysCategoryViews = SecurityView.where("securities.fund_category_id = ? and security_views.created_at >= ?",params[:id],Time.now-1.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)
      @thisWeeksCategoryViews = SecurityView.where("securities.fund_category_id = ? and security_views.created_at >= ?",params[:id],Time.now-7.days).joins(:security).group(:security_id).order("count(security_id) desc").limit(10)
      if @family.nil?
        @errors = 'Fund category not found'
      end
    end
  end

end
