class AdminController < ApplicationController

  def index
    @page_title = "Manage Users"
    @users = User.all.order("id ASC")
  end

  def show
    
  end


end
