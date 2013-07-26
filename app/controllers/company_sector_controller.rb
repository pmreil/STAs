class CompanySectorController < ApplicationController

  def index
    @allViews = CompanySector.all_views
  end

  def show
    if params[:id].nil?
      @errors = 'Sector Required'
    else
      @sector = CompanySector.where(:id => (params[:id])).first
      if @sector.nil?
        @errors = 'Sorry, no sector with that ID found'
      else
        @name = @sector.name
        name = "company_sector"
        @allViews = SecurityView.subset_views(name,params[:id])
        @todaysViews = SecurityView.subset_views(name,params[:id],1)
        @thisWeeksViews = SecurityView.subset_views(name,params[:id],7)
      end
    end
  end

end
