class ApplicationController < ActionController::Base
  include CurrentUserConcern
  
  def layout_by_resource
    if devise_controller? && (resource_name == :user)  && action_name != 'edit' && action_name != 'update'
      "devise"
    else
      "application"
    end
  end

end
