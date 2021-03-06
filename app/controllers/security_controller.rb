class SecurityController < ApplicationController

  def index
    @allSecurityViews = SecurityView.select("security_id, count(security_id) as views").where("security_views.created_at >= ?",Time.now-1.day).includes(:security).group("security_id").order("views desc").limit(10)

  end

    #DOES IT EXIST
    #IF IT DOES, INCREMEMENT THE VIEW
    #IF IT DOESN'T, GET THE DETAILS, CREATE THE RECORD
      #SEE IF ITS A STOCK OR A FUND
        #IF A STOCK, GET THE EXCHANGE AND SECTOR AND INDUSTRY
        #IF A FUND, GET THE FUND FAMILY and FUN CATEOGRY      


  def show
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Ticker Required'
    else
      trigger_security_view(params[:id])
    end
  end

  def trigger_security_view (ticker)
    #a ticker has been passed in
    #lets see if its already in the db.
    @security = Security.where(:ticker => (ticker)).first
    if @security.nil?    
      #its not there already
      #lets see if we can find a record of this ticker at all
      #this query returns either industry/sector for equities or category/fund family for funds
      stocks_query_url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.stocks%20where%20symbol%3D%22'+ticker+'%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'
      yql_response = Net::HTTP.get_response(URI.parse(stocks_query_url))
      json = ActiveSupport::JSON
      stocks_query_data = json.decode(yql_response.body)

      if !stocks_query_data['query']['results']['stock'].has_key?('CompanyName')
        @errors = "Ticker not found"
      else
        #okay we've loaded the details of the sector/industry or fund family/fund category_record
        #now lets get the exchange and name
        name_query_url = 'http://autoc.finance.yahoo.com/autoc?query='+ticker+'&callback=YAHOO.Finance.SymbolSuggest.ssCallback'
        yql_response2 = Net::HTTP.get_response(URI.parse(name_query_url))
        json2 = ActiveSupport::JSON
        yql_response2.body = yql_response2.body.gsub("YAHOO.Finance.SymbolSuggest.ssCallback(","").gsub(")","")
        name_query_data = json2.decode(yql_response2.body)
        stock_exchange = name_query_data['ResultSet']['Result'][0]['exchDisp']
        if (stock_exchange.nil?) 
          stock_exchange = name_query_data['ResultSet']['Result'][0]['exch']
        end            
        stock_exchange_record = SecurityExchange.where(:name => stock_exchange).first
        if stock_exchange_record.nil? && !stock_exchange.nil? #then lets add it
          stock_exchange_record = SecurityExchange.create(:name => stock_exchange)
        end

        isStock = stocks_query_data['query']['results']['stock']['FundFamily'].nil?
        if isStock
          sector = stocks_query_data['query']['results']['stock']['Sector']
          industry = stocks_query_data['query']['results']['stock']['Industry']
          sector_record = CompanySector.where(:name => sector).first
          if sector_record.nil? && !sector.nil? #then lets add it
            sector_record = CompanySector.create(:name => sector)
          end
          industry_record = CompanyIndustry.where(:name => industry).first
          if industry_record.nil? && !industry.nil?#then lets add it
            industry_record = CompanyIndustry.create(:name => industry)
          end
          @security = Security.create(
            :ticker => ticker,
            :name => name_query_data['ResultSet']['Result'][0]['name'],
            :exchange_id => stock_exchange_record.nil? ? nil : stock_exchange_record.id,
            :security_type => 'stock',
            :company_industry_id => industry_record.nil? ? nil : industry_record.id,
            :company_sector_id => sector_record.nil? ? nil : sector_record.id
          )
        else #then its a fund
          category = stocks_query_data['query']['results']['stock']['Category']
          fund_family = stocks_query_data['query']['results']['stock']['FundFamily']
          category_record = FundCategory.where(:name => category).first
          if category_record.nil? && !category.nil? #then lets add it
            category_record = FundCategory.create(:name => category)
          end
          fund_family_record = FundFamily.where(:name => fund_family).first
          if fund_family_record.nil? && !fund_family.nil? #then lets add it
            fund_faily_record = FundFamily.create(:name => fund_family)
          end
          @security = Security.create(
            :ticker => ticker,
            :name => name_query_data['ResultSet']['Result'][0]['name'],
            :exchange_id => stock_exchange.nil? ? nil : stock_exchange_record.id,
            :security_type => 'fund',
            :fund_category_id => category_record.nil? ? nil :   category_record.id,
            :fund_family_id => fund_family_record.nil? ? nil : fund_family_record.id
          )
        end
      end
    end

    if !@security.nil? && cookies[ticker].nil?
      #cookie hasnt been set or has expired, so lets save this view
      #finally set a cookie for 10 minutes so reloads arent triggered
      security_view_record = SecurityView.create(
        :security_id => @security.id,
        :viewer_ip_address => request.remote_ip,
        :viewer_browser_string => request.env['HTTP_USER_AGENT'].nil? ? "" : request.env['HTTP_USER_AGENT'].downcase,
        :lat => request.location.data['latitude'],
        :lng => request.location.data['longitude'],
        :city => request.location.data['city'],
        :state => request.location.data['region_code'],
        :zip => request.location.data['zipcode'],
        :country => request.location.data['country_name'],
      )
      cookies[ticker] = { :value => "visited", :expires => 10.minutes.from_now }
    end

    #okay it is in the system - lets load is past trends
    @security_views = @security.security_views.order("id desc").limit(100)
    @security_trends = Array[
        @security.percentage_weekly_views(10),
        @security.percentage_weekly_views(9),
        @security.percentage_weekly_views(8),
        @security.percentage_weekly_views(7),
        @security.percentage_weekly_views(6),
        @security.percentage_weekly_views(5),
        @security.percentage_weekly_views(4),
        @security.percentage_weekly_views(3),
        @security.percentage_weekly_views(2),
        @security.percentage_weekly_views(1),
       ]

    #if we dont have the name for it load it now
    if @security.name == ""
      #lets get the exchange and name
      name_query_url = 'http://autoc.finance.yahoo.com/autoc?query='+ticker+'&callback=YAHOO.Finance.SymbolSuggest.ssCallback'
      yql_response = Net::HTTP.get_response(URI.parse(name_query_url))
      json = ActiveSupport::JSON
      yql_response.body = yql_response.body.gsub("YAHOO.Finance.SymbolSuggest.ssCallback(","").gsub(")","")
      name_query_data = json.decode(yql_response.body)
      @security.name = name_query_data['ResultSet']['Result'][0]['name']
      @security.save
    end
    
  end

end

