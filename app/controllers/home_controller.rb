class HomeController < ApplicationController
  access all: [:about, :index]

  def index
    @page_title = "Home Page"
  end

  def about
    @page_message = "Report Manager"
  end
end
