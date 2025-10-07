module Admin
  class BaseController < ApplicationController
    layout "application"

    before_action :enable_admin_mode

    private

    def enable_admin_mode
      @admin_area = true
    end
  end
end
