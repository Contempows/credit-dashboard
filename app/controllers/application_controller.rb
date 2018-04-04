class ApplicationController < ActionController::Base
  layout :layout_none_devise

  protect_from_forgery with: :exception

  helper_method :is_au?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, notice: exception.message }
    end
  end

  def is_au?
    current_user.au?
  end

  def is_staff?
    current_user.staff?
  end

  private

  def _run_options(options)
    options.merge(current_user: current_user)
  end

  def after_sign_out_path_for(_resourse_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  protected

  def layout_none_devise
    'appdevise' if devise_controller?
  end
end
