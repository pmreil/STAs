class CompanySectorController < ApplicationController

  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Sector Required'
    else
      @sector = CompanySector.where(:id => (params[:id])).first
      @allSectorViews = SecurityView.select("security_id, securities.name, count(security_id) as total_views").includes(:security).where("securities.company_sector_id = ?",params[:id]).group("security_id")#.order("total_views desc")

      if @sector.nil?
        @errors = 'Sector not found'
      end
    end
  end

end
