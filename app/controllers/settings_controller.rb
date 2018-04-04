class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @setting = Setting.last
  end

  def new
    @setting = Setting.new
    @setting.ssn_charge = ''
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def create
    @setting = Setting.new(setting_params)
    flash[:notice] = I18n.t('ssn_charge.added') if @setting.save
  end

  def edit
    @setting = Setting.find(params[:id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'settings/new.js' }
    end
  end

  def update
    @setting = Setting.last
    flash[:notice] = I18n.t('ssn_charge.updated') if @setting.update(setting_params)
    render 'settings/create.js'
  end

  private

  def setting_params
    params.require(:setting).permit(:ssn_charge)
  end
end
