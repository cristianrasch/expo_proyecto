ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => Conf.smtp["user_name"],
  :password             => Conf.smtp["password"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
