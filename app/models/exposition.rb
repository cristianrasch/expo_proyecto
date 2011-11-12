# encoding: utf-8

class Exposition < ActiveRecord::Base
  include DateUtils
  
  validates :year, :numericality => true, :uniqueness => true
  validates :name, :uniqueness => { :allow_blank => true }
  validate :dates_do_not_overlap

  has_many :projects, :order => 'created_at desc, title', :dependent => :destroy
  has_many :activities, :order => 'starts_at', :dependent => :delete_all
  
  scope :sorted, order('year desc')

  attr_accessible :year, :name, :start_date, :end_date
  date_writer_for :start_date, :end_date

  before_save :set_default_name, :set_default_dates
  
  def print_projects_pdfs
    PDFPrinter.print_pdfs projects.includes(:exposition, :authors)
  end
  
  def print_projects_tags
    PDFPrinter.print_tags projects.includes(:authors)
  end
  
  def print_projects_requirements
    PDFPrinter.print_requirements projects.with_extra_needs
  end
  
  def filter_projects(template)
    res = projects
    
    %w(faculty  group_type expo_mode).each do |attr|
      val = template.send(attr)
      res = res.where(attr => val) if val.present?
    end
    
    res = res.where('subject ilike ?', "%#{template.subject}%") if template.subject.present?
    
    res.order("created_at desc")
  end
  
  private
  
  def set_default_name
    self.name = "ExpoProyecto #{year}" if name.blank?
  end
  
  def set_default_dates
    today = Date.today
    date = today.advance(:years => year - today.year)
    self.start_date = date.at_beginning_of_year if start_date.blank?
    self.end_date = date.at_end_of_year if end_date.blank?
  end
  
  def dates_do_not_overlap
    errors.add(:end_date, 'es inválida') if start_date && end_date && start_date >= end_date
  end
end
