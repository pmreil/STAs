class SecurityController < ApplicationController

    #DOES IT EXIST
    #IF IT DOES, INCREMEMENT THE VIEW
    #IF IT DOESN'T, GET THE DETAILS, CREATE THE RECORD
      #SEE IF ITS A STOCK OR A FUND
        #IF A STOCK, GET THE EXCHANGE AND SECTOR AND INDUSTRY
        #IF A FUND, GET THE FUND FAMILY and FUN CATEOGRY      


  def loadTicker
    if params[:id].nil?
      #they didnt pass anything in - abort
      @errors = 'Ticker Required'
    else
      #a ticker has been passed in
      #lets see if its already in the db.
      @security = Security.where(:ticker => (params[:id])).first
      if @security.nil?    
        #its not there already
        #lets see if we can find a record of this ticker at all
        #this query returns either industry/sector for equities or category/fund family for funds
        stocks_query_url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.stocks%20where%20symbol%3D%22'+params[:id]+'%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'
        yql_response = Net::HTTP.get_response(URI.parse(stocks_query_url))
        json = ActiveSupport::JSON
        stocks_query_data = json.decode(yql_response.body)
        if stocks_query_data['query']['results']['stock']['CompanyName'].nil?
          @errors = "Ticker not found"
        else
          cookies[params[:id]] = { :value => "visited", :expires => 10.minutes.from_now }
          isStock = stocks_query_data['query']['results']['stock']['FundFamily'].nil?
          if isStock
            sector = stocks_query_data['query']['results']['stock']['Sector']
            industry = stocks_query_data['query']['results']['stock']['Industry']
            sector_record = CompanySector.where(:name => sector).first
            if sector_record.nil? #then lets add it
              sector_record = CompanySector.create(:name => sector)
            end
            industry_record = CompanyIndustry.where(:name => industry).first
            if industry_record.nil? #then lets add it
              industry_record = CompanyIndustry.create(:name => industry)
            end
          else #then its a fund
            category = stocks_query_data['query']['results']['stock']['Category']
            fund_family = stocks_query_data['query']['results']['stock']['FundFamily']
            category_record = FundCategory.where(:name => category).first
            if category_record.nil? #then lets add it
              category_record = FundCategory.create(:name => category)
            end
            fund_family_record = FundFamily.where(:name => fund_family).first
            if fund_family_record.nil? #then lets add it
              fund_faily_record = FundFamily.create(:name => fund_family)
            end
          end
          #okay we've loaded the details of the sector/industry or fund family/fund category_record
          #now lets get the exchange and name
          quotes_query_url = 'http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20%22'+params[:id]+'%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys'
          yql_response = Net::HTTP.get_response(URI.parse(quotes_query_url))
          quotes_query_data = json.decode(yql_response.body)
          stock_exchange = quotes_query_data['query']['results']['quote']['StockExchange']
          stock_exchange_record = SecurityExchange.where(:name => stock_exchange).first
          if stock_exchange_record.nil? #then lets add it
            stock_exchange_record = SecurityExchange.create(:name => stock_exchange)
          end

          #okay lets finally add the record to the security table
          if isStock
            @security = Security.create(
              :ticker => params[:id],
              :name => stocks_query_data['query']['results']['stock']['CompanyName'],
              :exchange_id => stock_exchange_record.id,
              :security_type => 'stock',
              :company_industry_id => industry_record.id,
              :company_sector_id => sector_record.id
            )
          else
            @security = Security.create(
              :ticker => params[:id],
              :name => stocks_query_data['query']['results']['stock']['CompanyName'],
              :exchange_id => stock_exchange_record.id,
              :security_type => 'fund',
              :fund_category_id => category_record.id,
              :fund_family_id => fund_family_record.id
            )
          end
        end
        @security_trends = nil
      else
      #okay it is in the system - lets load is past trends
        @security_trends = Array[
          @security.percentage_views(100),
          @security.percentage_views(90),
          @security.percentage_views(80),
          @security.percentage_views(70),
          @security.percentage_views(60),
          @security.percentage_views(50),
          @security.percentage_views(40),
          @security.percentage_views(30),
          @security.percentage_views(20),
          @security.percentage_views(10)
         ]
      end

      if cookies[@security.ticker].nil?
        #cookie hasnt been set or has expired, so lets save this view
        #finally set a cookie for 10 minutes so reloads arent triggered
        security_view_record = SecurityView.create(
          :security_id => @security.id,
          :viewer_ip_address => request.remote_ip,
          :viewer_browser_string => request.env['HTTP_USER_AGENT'].downcase
        )
        cookies[@security.ticker] = {:value => 1, :expires => 10.minutes.from_now }
      end

    end    

  end

  def loadTwitterFeed
    @feedUrl = "http://search.twitter.com/search.atom?q=%24"+params[:id]
    @feed = Feedzirra::Feed.fetch_and_parse(@feedUrl)
    puts @feed
    render :layout => false
  end

  def loadGoogleNews
    @feedUrl = 'http://www.google.com/finance/company_news?q='+params[:id]+'&output=rss'
    @feed = Feedzirra::Feed.fetch_and_parse(@feedUrl)
    render :layout => false
  end

  def loadGoogleBlog
    @feedUrl = 'http://www.google.com/search?q='+params[:id]+'&hl=en&tbm=blg&output=atom'
    #@feedUrl = 'http://www.google.com/search?hl=en&q="'+params[:id]+'"&ie=utf-8&tbm=blg&output=rss'
    @feed = Feedzirra::Feed.fetch_and_parse(@feedUrl)
    render :layout => false
  end


end
