module DashboardHelper
  def profile_empty?
    (current_user.first_name.empty? || current_user.last_name.empty? ||
     current_user.address.empty? || current_user.phone.empty? ||
     current_user.zipcode.empty?)
  end
end
