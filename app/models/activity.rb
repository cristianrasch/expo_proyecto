class Activity < ActiveRecord::Base
  include DateUtils
  
  validates :title, :presence => true, :uniqueness => { :scope => :exposition_id }
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validates :exposition_id, :numericality => true
  validate :must_have_valid_start_and_end_dates
  
  belongs_to :exposition
  
  attr_accessible :title, :starts_at, :ends_at
  datetime_writer_for :starts_at, :ends_at
  
  def to_s
    "#{title} (el #{I18n.l(starts_at, :format => :short)})"
  end
 
  private
  
  def must_have_valid_start_and_end_dates
    %w(starts_at ends_at).each do |attr|
      attr_value = send(attr)
      errors.add(attr) if attr_value && exposition && attr_value.year != exposition.year
    end
    
    errors.add(:ends_at) if starts_at && ends_at && starts_at > ends_at
  end
end
