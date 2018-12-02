# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
	:user_name => "app117633146@heroku.com",
	:password => "vk1soxun9121",
	:domain => 'secure-ocean-56846.herokuapp.com',
	:address => 'smtp.sendgrid.net',
	:port => 587,
	:authentication => :plain,
	:enable_starttls_auto => true
}
