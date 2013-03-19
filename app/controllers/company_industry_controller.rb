class CompanyIndustryController < ApplicationController

  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Industry Required'
    else
      @industry = CompanyIndustry.where(:name => (params[:id])).first
      if @industry.nil?
      end
    end
  end

end
