class MessagesMailer < ActionMailer::Base
  default :from => Conf.devise['mailer_sender']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.messages_mailer.new_message.subject
  #
  def new_message(message)
    @message = message
    mail :to => message.recipients, :subject => @message.subject
  end
end
