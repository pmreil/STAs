module ApplicationHelper

	def render_title
  	return @title + " - Stock Ticker Apps" if defined?(@title)
  	"Stock Ticker Apps"
	end

	def display_ads?
 		ENV['RAILS_ENV'] == "production"
	end

end
