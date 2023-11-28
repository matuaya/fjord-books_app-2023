# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    permitted_params = %i[name address postal_code]
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted_params)
    devise_parameter_sanitizer.permit(:account_update, keys: [:self_introduction, *permitted_params])
  end
end
