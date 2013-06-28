# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
SampleApp::Application.initialize!

require 'tlsmail'
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.raise_delivery_errors = true

mail_settings = YAML.load(File.read(File.join(Rails.root, 'config', 'mail.yml')))

ActionMailer::Base.smtp_settings = {
  :domain          => mail_settings['email_address'],
  :address         => mail_settings['smtp_server'],

  :port            => mail_settings['smtp_port'],
  :tls             => true,
  :authentication  => :plain,
  :user_name       => mail_settings['smtp_username'],
  :password        => mail_settings['smtp_password']
}
