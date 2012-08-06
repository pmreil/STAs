require 'spec_helper'

describe "URLTests" do

    it "should have an about page at /about/" do
      get '/about/'
      response.status.should be(200)
    end

end
