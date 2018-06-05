module DeviseWhitelist
  extend ActiveSupport::Concern
  
  included do 
    before_action :configured_permitted_parameters, if: :devise_controller?
  end

  def configured_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :signature])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :signature])
  end
end