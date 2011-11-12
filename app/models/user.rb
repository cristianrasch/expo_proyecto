class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :projects
  
  scope :not_admin, where(:admin => false)
  
  def inactive_message
    "Disculpe, esta cuenta ha sido desactivada."
  end
  
  def active_for_authentication?
    active?
  end
  
  def self.deactivate_expired_accounts
    exposition_ids = Exposition.where(["end_date < ? and users_deactivated = ?", Date.today, false]).map(&:id)
    
    if exposition_ids.present?
      not_admin.where(:projects => {:exposition_id => exposition_ids}).joins(:projects).
                readonly(false).find_each do |user|
        user.update_attribute :active, false
      end
      
      Exposition.update_all(["users_deactivated = ?", true], :id => exposition_ids)
    end
  end
end
