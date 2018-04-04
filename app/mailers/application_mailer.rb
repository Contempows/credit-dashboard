class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper
  default from: 'service@ctctradelines.com'
  layout 'mailer'
end
