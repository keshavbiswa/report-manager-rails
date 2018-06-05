class AdminController < ApplicationController

  def index
    @page_title = "Manage Users"
    @users = User.all.order("id ASC")
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])

    if @user.has_roles?(:site_admin)
      respond_to do |format|
        format.html { redirect_to admin_index_path, alert: "User #{@user.name} is an admin and cannot be removed removed." }
      end
    else
      @user.destroy
        
      respond_to do |format|
        format.html { redirect_to admin_index_path, notice: "User #{@user.name} was successfully removed." }
      end
    end
  end
end