module ApplicationHelper

	def render_title
  	return @title + " - Stock Ticker Apps" if defined?(@title)
  	"Stock Ticker Apps"
	end

end
