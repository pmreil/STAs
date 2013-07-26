class CompanyIndustryController < ApplicationController

  def index
    @allViews = CompanyIndustry.all_views
  end

  def show
    if params[:id].nil?
      @errors = 'Industry Required'
    else
      @industry = CompanyIndustry.where(:id => (params[:id])).first
      if @industry.nil?
        @errors = 'Sorry, no industry found with this id'
      else
        @name = @industry.name
        name = "company_industry"
        @allViews = SecurityView.subset_views(name,params[:id])
        @todaysViews = SecurityView.subset_views(name,params[:id],1)
        @thisWeeksViews = SecurityView.subset_views(name,params[:id],7)
      end
    end
  end
end
