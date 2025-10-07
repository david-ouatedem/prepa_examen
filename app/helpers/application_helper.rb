module ApplicationHelper
  # returns 'active' when the current controller is the target admin controller
  def admin_nav_active_class(target_controller)
    return '' unless params[:controller].start_with?('admin/')
    params[:controller].split('/').second == target_controller.to_s ? 'active' : ''
  end
end
