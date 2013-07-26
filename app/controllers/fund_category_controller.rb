class FundCategoryController < ApplicationController

  def index
    @allViews = FundCategory.all_views
  end

  def show
    if params[:id].nil?
      @errors = 'Fund Category ID Required'
    else
      @category = FundCategory.where(:id => (params[:id])).first
      if @category.nil?
        @errors = 'Sorry, no fund category with that ID found'
      else
        @name = @category.name
        name = "fund_category"
        @allViews = SecurityView.subset_views(name,params[:id])
        @todaysViews = SecurityView.subset_views(name,params[:id],1)
        @thisWeeksViews = SecurityView.subset_views(name,params[:id],7)
      end
    end
  end

end
