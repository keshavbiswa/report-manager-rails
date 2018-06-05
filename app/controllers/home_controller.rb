class HomeController < ApplicationController
  access site_admin: :all

  def index
    @page_title = "Home Page"
  end

  def about
    @page_message = "Report Manager"
  end
end
