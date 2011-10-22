class Message < Struct.new(:source, :recipients, :subject, :text)
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  
  include ActiveModel::Conversion
  include ActiveModel::Validations
  
  validates :recipients, :presence => true
  validates :subject, :presence => true
  validates :text, :presence => true

  attr_reader :errors
  
  # Messages are never persisted in the DB
  def persisted?
    false
  end

  def initialize(attrs = {})
    attrs.each {|k, v| send("#{k}=", v)}
    @errors = ActiveModel::Errors.new(self)
  end
  
  def source=(src)
    super
    if src
      self.recipients, email_reg_exp = [], Regexp.new(Conf.email_reg_exp)
      
      projects = Project.where("contact is not null").where("length(contact) > 0")
      case(src)
        when Exposition then projects = projects.where(:exposition_id => src.id)
        when Project then projects = projects.where(:id => src.id)
      end
      
      projects.map(&:contact).each do |contact|
        self.recipients.concat(contact.scan(email_reg_exp).map {|email| email.downcase})
      end
    end
  end
end
