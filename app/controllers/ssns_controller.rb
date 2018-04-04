class SsnsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.staff?
      @users = Ssn.latest_ssns_group_by_users.keys
    else
      flash[:error] = 'You are not authorized to view this page'
      redirect_to root_path
    end
  end
end
