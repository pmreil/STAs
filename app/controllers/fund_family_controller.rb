class FundFamilyController < ApplicationController

  def index
    @allViews = FundFamily.all_views
  end

  def show
    if params[:id].nil?
      @errors = 'Fund Family ID Required'
    else
      @family = FundFamily.where(:id => (params[:id])).first
      if @family.nil?
        @errors = 'Sorry, no fund family with that ID found'
      else
        @name = @family.name
        name = "fund_family"
        @allViews = SecurityView.subset_views(name,params[:id])
        @todaysViews = SecurityView.subset_views(name,params[:id],1)
        @thisWeeksViews = SecurityView.subset_views(name,params[:id],7)
      end
    end
  end

end
