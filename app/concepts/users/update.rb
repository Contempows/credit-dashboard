class Users::Update < Trailblazer::Operation
  step :process!

  def process!(options, params:, **)
    #options['model'] = params[:user]
    #date = nil
    #puts params.inspect
    #day = params[:params][:user][:day]
    #month = params[:params][:user][:month]
    #year = params[:params][:user][:year]
    #if day.present? && month.present? && year.present?
    #  date = Date.new(year.to_i, Date::MONTHNAMES.index(month), day.to_i)
    #end
    #options['model'].attributes = params[:user_params].merge(date_of_birth: date)
    #options['model'].save
  end
end
