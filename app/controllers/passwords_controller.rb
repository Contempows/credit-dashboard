class PasswordsController < Devise::PasswordsController
  layout 'appdevise'

  def update
    super do
      current_user.try(:increment_sign_in_count)
    end
  end

  protected

  def after_resetting_password_path_for(_resource)
    sign_out(current_user)
    new_user_session_path
  end
end
