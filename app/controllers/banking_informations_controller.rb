class BankingInformationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @banking_infos = BankingInformation.all
    if current_user.au?
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'banking_informations/index.js' }
      end
    else
      @banking_infos = @banking_infos.paginate_and_order(params[:page], 10)
      render 'banking_informations/index.html.haml'
    end
  end

  def new
    @banking_information = BankingInformation.new
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def edit
    @banking_information = BankingInformation.find(params[:id])
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def create
    if current_user.senior?
      @banking_information = BankingInformation.new(banking_information_params)
      @banking_information.save
      flash[:notice] = I18n.t('banking_info.added') unless @banking_information.errors.any?
    end
  end

  def show
    @banking_information = BankingInformation.find(params[:id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def update
    if current_user.senior?
      @banking_information = BankingInformation.find(params[:id])
      @banking_information.update_attributes(banking_information_params)
      flash[:notice] = I18n.t('banking_info.updated') unless @banking_information.errors.any?
      render file: 'banking_informations/create.js'
    end
  end

  def destroy
    BankingInformation.find(params[:id]).destroy
    redirect_to banking_informations_path
  end

  private

  def banking_information_params
    params.require(:banking_information).permit(:account_number, :routing_info,
                                                :bank_name, :account_name)
  end
end
