class UsersController < ApplicationController
  layout 'appdevise', except: %i[index applications edit_details update_details
                                 edit_password update_password]

  before_action :set_user, only: %i[edit_ssns edit_password
                                    update_ssns update_password]
  before_action :authenticate_user!, except: %i[new create edit update]

  def index
    if current_user.staff?
      @users = if params[:term]
        User.normal_accounts.search(params[:term].downcase)
      else
        User.normal_accounts
      end.paginate_and_order(params[:page], 7)
    else
      flash[:error] = 'You are not authorized to view this page'
      redirect_to root_path
    end
  end

  def new
    if user_signed_in?
      @user = User.new
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    else
      @user = User.find(params[:id]) if params[:id].present?
      @user ||= User.new
    end
  end

  def create
    @user = current_user
    if user_signed_in?
      role = current_user.au? ? 'au' : 'junior'
      @user = User.new(user_params.merge(status: 'accepted', password: '123456',
                                         invited_by: current_user, role: role))
      @result = @user.update(user_params)
      if @result.success?
        flash[:notice] = if current_user.au?
          I18n.t('user.au_user_added')
        else
          I18n.t('user.ss_js_added')
        end
      end
      respond_to do |format|
        format.js
      end
    else
      @user = User.new(user_params.merge(status: 0, role: 0))
      if @user.update(user_params)
        redirect_to edit_user_path(id: @user.id)
      else
        render 'new'
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @ledger_entries = @user.ledger_entries.limit(3).order_desc unless current_user.au?
    @is_broker = User.normal_accounts.include?(@user)
    respond_to do |format|
      format.html { redirect_to ledger_entries_path(user_check_id: @user.id) }
      format.js
      format.json do
        render json: { id: @user.id, firstname: @user.first_name, lastname: @user.last_name,
                       address: @user.address, dob: @user.date_of_birth, ssn: @user.social }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if user_signed_in?
      respond_to do |format|
        format.html { redirect_to applications_users_path }
        format.js
      end
    end
  end

  def update
    @user = User.find(params[:id])
    flash[:notice] = I18n.t('user.sign_up_message') if @user
    if user_signed_in? && @user.invited_by_id == current_user.id
      @result = false
      if @user.update(user_params)
        @result = true
        flash[:notice] = @user.au? ? I18n.t('user.au_user_updated') : I18n.t('user.ss_js_updated')
      end
      respond_to do |format|
        format.js
      end
    else
      if @user.update(user_params)
        if params[:step] == '1'
          redirect_to edit_user_path(id: @user.id, step: 2)
        else
          UserMailer.au_created_mail(@user).deliver_later
          sign_in(@user)
          redirect_to root_path
        end
      else
        render 'edit'
      end
    end
  end

  def edit_ssns
    @user = if current_user.au?
      current_user
    else
      User.find(params[:id])
    end
    current_user.ssns.build(status: 'requested')

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def update_ssns
    if current_user.au?
      ssn_count = current_user.ssns.count
      if params[:user]
        @result = current_user.update(user_params)
        SsnMailer.ssn_secured(current_user).deliver_later if @result && ssn_count < current_user.ssns.count
      end
      flash[:notice] = I18n.t('ssncpn.requested') if @result && ssn_count != current_user.ssns.count
    else
      @user = User.find(params[:id])
      flash[:notice] = I18n.t('ssncpn.updated') if @user.update(user_params)
    end

    respond_to do |format|
      format.js
    end
  end

  def edit_details
    if params[:profile_details] == 'true'
      @user = current_user
    else
      @user = User.find(params[:id])
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def update_details
    if params[:full_page] == 'true'
      @user = current_user
      if @user.update(user_params)
        flash[:notice] = I18n.t('user.details_updated')
        redirect_to root_path
      else
        render 'edit_details'
      end
    else
      @user = User.find(params[:id])
      @result = @user.update(user_params)
      UserMailer.au_accepted_mail(@user).deliver_later if @user.accepted?
      flash[:notice] = I18n.t('user.details_updated') if @result
      redirect_back(fallback_location: root_path) if @result
    end
  end

  def edit_password; end

  def update_password
    path = @user.sign_in_count > 1 ? root_path : new_user_session_path
    if @user.update(user_params)
      @user.sign_in_count == 1 ? sign_out(@user) : sign_in(@user, bypass: true)
      redirect_to path
      flash[:notice] = I18n.t('user.password_updated') if user_signed_in?
    else
      render 'edit_password'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if current_user.senior?
      redirect_to :back
      flash[:notice] = I18n.t('user.js_deleted')
    else
      redirect_to applications_users_path
      flash[:notice] = I18n.t('user.au_deleted')
    end
  end

  def applications
    redirect_to(root_path) && return if current_user.junior?
    @applications = if params[:junior] && current_user.senior?
      User.where(role: 1)
    elsif current_user.senior?
      User.applications
    else
      User.where(invited_by_id: current_user.id).includes(:purchases, :withdraws, :deposits)
    end

    if params[:term]
      @applications = @applications.search(params[:term].downcase)
    end
    @applications = @applications.paginate_and_order(params[:page], 8)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :social,
                                 :password_confirmation, :first_name, :last_name,
                                 :address, :phone, :zipcode, :city, :state,
                                 :day, :month, :year, :mother_maiden_name, :date_of_birth,
                                 :status, :profile, :count, ssns_attributes: %i[id ssnorcpn _destroy status])
    # month, date, year = params[:user][:date_of_birth].split('/')
    # params[:user][:date_of_birth] = Date.new(year.to_i, month.to_i, date.to_i)
  end
end
