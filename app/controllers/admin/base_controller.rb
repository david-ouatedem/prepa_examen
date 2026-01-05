module Admin
  class BaseController < ApplicationController
    layout "application"

    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :enable_admin_mode

    private

    def enable_admin_mode
      @admin_area = true
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: "You are not authorized to access this area."
      end
    end
  end
end
