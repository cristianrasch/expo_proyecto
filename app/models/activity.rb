class Activity < ActiveRecord::Base
  include DateUtils
  
  validates :title, :presence => true, :uniqueness => { :scope => :date }
  validates :date, :presence => true
  validates :from, :presence => true
  validates :to, :presence => true
  validates :exposition_id, :numericality => true
  validate :must_have_a_valid_date
  validate :must_have_a_valid_hour_range
  
  belongs_to :exposition
  
  attr_accessible :title, :date, :from, :to
  date_writer_for :date
  
  before_save :humanize_title
  
  def to_s
    "#{title} (el #{I18n.l(date, :format => :short)} de #{from} a #{to})"
  end
  
  private
  
  def humanize_title
    self.title = title.humanize
  end
  
  def must_have_a_valid_date
    errors.add(:date) if date && exposition && date.year != exposition.year
  end
  
  def must_have_a_valid_hour_range
    errors.add(:to) if from && to && from.delete(':').to_i >= to.delete(':').to_i
  end
end
