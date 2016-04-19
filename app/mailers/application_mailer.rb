class ApplicationMailer < ActionMailer::Base
  default from: Rails.env == "development" ? ENV["GMAIL_USERNAME"] : ENV["MAILGUN_SMTP_LOGIN"]
  layout "mailer"
end
