class CompanyIndustryController < ApplicationController

  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Industry Required'
    else
      @industry = CompanyIndustry.where(:id => (params[:id])).first
      if @industry.nil?
        @errors = 'Industry not found'
      else
        #@topfive = Security.
      end
    end
  end

end
