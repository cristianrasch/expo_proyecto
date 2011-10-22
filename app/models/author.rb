class Author < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => { :allow_blank => true, :scope => :project_id }
  
  belongs_to :project
  
  attr_accessible :name
  
  before_create :titleize_name
  
  private
  
  def titleize_name
    self.name = name.titleize
  end
end
