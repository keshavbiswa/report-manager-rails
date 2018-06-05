class HomeController < ApplicationController
  
  def index
    @page_title = "Home Page"
  end

  def about
    @page_message = "Report Manager"
  end
end
