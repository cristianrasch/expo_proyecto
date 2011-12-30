# encoding: utf-8

require 'open-uri'

class Project < ActiveRecord::Base
  include ProjectUtils
  include Prawn::Measurements

  validates :title, :presence => true, :uniqueness => { :scope => :exposition_id }
  validates :faculty, :numericality => { :message => I18n.t('errors.messages.blank'), :if => :not_in_dev? }, 
                      :inclusion => { :in => Conf.faculties.values, :allow_nil => true }
  validates :other_faculty, :presence => { :if => Proc.new { |proj| proj.other_faculty_required? } }
  validates :subject, :presence => true
  validates :group_type, :numericality => { :message => I18n.t('errors.messages.blank'), :if => :not_in_dev? }, 
                         :inclusion => { :in => Conf.group_types.values, :allow_nil => true }
  validates :other_group, :presence => { :if => Proc.new { |proj| proj.other_group_required? } }
  validates :contact, :presence => true unless Rails.env.development?
  validates :expo_mode, :numericality => { :message => I18n.t('errors.messages.blank'), :if => :not_in_dev? }, 
                        :inclusion => { :in => Conf.expo_modes.values, :allow_nil => true }
  validates :description, :presence => true unless Rails.env.development?
  validate :must_have_at_least_one_author
  validates :exposition_id, :numericality => true
  
  validates :needs_projector_reason, 
            :presence => { :unless => Proc.new { |proj| proj.needs_projector.to_i.zero? } }
  validates :needs_screen_reason, :presence => { :unless => Proc.new { |proj| proj.needs_screen.to_i.zero? } }
  validates :needs_poster_hanger_reason, 
            :presence => { :unless => Proc.new { |proj| proj.needs_poster_hanger.to_i.zero? } }
  
  belongs_to :exposition
  belongs_to :user
  has_many :authors, :dependent => :delete_all
  accepts_nested_attributes_for :authors, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

  scope :with_images, where("image_file_name is not null")

  attr_reader :remove_image
  attr_accessor :needs_projector, :needs_screen, :needs_poster_hanger
  attr_accessible :title, :faculty, :subject, :group_type, :contact, :expo_mode, :description, 
                  :competes_to_win_prizes, :authors_attributes, :image, :image_cache, :remove_image,
                  :requirements, :lab_gear, :sockets_count, :needs_projector, :needs_projector_reason,
                  :needs_screen, :needs_screen_reason, :needs_poster_hanger, :needs_poster_hanger_reason,
                  :other_faculty, :other_group, :remove_image, :approval_time, :position
  
  has_attached_file :image,
                    :styles => { :small => '320x200>', :thumb => '100x100>' },
                    :default_url => '/images/default.gif',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:filename'
  
  %w[faculty group].each do |attr|
    before_save "clear_other_#{attr}_if_not_required"
    
    define_method("clear_other_#{attr}_if_not_required") do
      self.send("other_#{attr}=", nil) unless send("other_#{attr}_required?")
    end
    
    private "clear_other_#{attr}_if_not_required"
  end
  
  %w[requirements lab_gear].each do |attr|
    define_method("#{attr}=") do |value|
      write_attribute(attr, value.present? ? value : nil)
    end
  end
  
  %w[needs_projector_reason needs_screen_reason needs_poster_hanger_reason].each do |method|
    define_method("#{method}=") do |need|
      if send(method[/(.+)_reason\z/, 1]).to_i.zero?
        write_attribute method, nil
      else
        write_attribute method, need
      end
    end
  end
  
  def approval_time=(time)
    if sumo_robot? && time =~ /(\d{1,2}):(\d{1,2})/
      t = $1.to_i.minutes.to_i + $2.to_i
      write_attribute :approval_time, t
    end
  end
  
  def approval_time
    t = read_attribute(:approval_time)
    if t
      m, s = t/60, t%60
      "#{"%02d" % m}:#{"%02d" % s}"
    else
      '00:00'
    end
  end
  
  def approval_time?
    approval_time != '00:00'
  end
  
  def position=(pos)
    write_attribute :position, :pos if sumo_robot?
  end
  
  # {"0"=>{"name"=>"Cristian", "id"=>"16", "_destroy"=>"1"}}
  def authors_attributes=(attributes)
    attributes.each do |id, hash|
      id, name = hash['id'], hash['name']
      
      if hash['id']
        if hash['_destroy'] == '1'
          authors.find(id).delete
        else
          authors.find(id).update_attribute(:name, name) if name.present?
        end
      else
        authors.build(:name => name) if name.present?
      end
    end
  end
  
  def to_pdf(doc = nil)
    if doc
      render = false
    else
      doc = Prawn::Document.new(:page_size => [cm2pt(13.5), cm2pt(20)], :margin => [5, 10])
      render = true
    end
    
    box = doc.margin_box
    y = box.absolute_top_left.last-25
    doc.move_to box.left, box.top
    doc.line_to box.right, box.top
    doc.stroke
    
    doc.move_down 10
    doc.text 'Universidad Nacional de La Matanza', :size => 16, :style => :bold, :align => :center
    doc.move_down 5
    doc.text 'Departamento de Ingeniería e Investigaciones Tecnológicas', :size => 10, :align => :center
    doc.move_down 20
    if image?
      begin
        doc.float { doc.image open(image.url(:thumb)), :fit => [102, 79] }
        doc.image File.join(Rails.public_path, 'images', 'logo.png'), :position => :right, :scale => 0.3
      rescue OpenURI::HTTPError
        doc.image File.join(Rails.public_path, 'images', 'logo.png'), :position => :center, :scale => 0.3
      end
    else
      doc.image File.join(Rails.public_path, 'images', 'logo.png'), :position => :center, :scale => 0.3
    end
    doc.move_down 10
    doc.text exposition.name, :size => 16, :style => :bold
    
    doc.line_width 1
    doc.move_to box.left, doc.y-10
    doc.line_to box.right, doc.y-10
    
    items = []
    items << ['Autores:', authors_names]
    items << ['Carrera:', fcty_desc]
    items << ['Materia:', subject]
    items << ['Tipo de grupo:', grp_desc]
    items << ['Compite:', competes_to_win_prizes ? 'Compite' : 'No compite']
    items << ['Contacto:', contact]
    items << ['ID:', identifier]
    items << ['Modalidad:', expo_mode_desc(expo_mode)]
    items << ['Título:', title]
    doc.table items, :cell_style => { :borders => [], :size => 10 } do
      row(0).style :padding_top => 15
      style(column(0)) do |c| 
        c.font_style = :bold
        c.size = 8
      end
      row(8).style :padding_top => 15
      row(8).style :font_style => :bold, :size => 12
    end
    
    doc.move_to box.left, doc.y-5
    doc.line_to box.right, doc.y-5
    doc.stroke
    
    doc.move_down 10
    doc.text_box description, :at => [box.left, doc.y], :size => 10, :align => :justify, 
                              :overflow => :shrink_to_fit
    
    doc.line_width 2
    doc.move_to box.left, box.bottom
    doc.line_to box.right, box.bottom
    doc.stroke
    
    doc.render if render
  end
  
  def not_in_dev?
    ! Rails.env.development?
  end
  
  def editable_by?(user)
    user && (user.admin? || user.id == user_id)
  end
  
  def other_faculty_required?
    faculty.to_i < 0
  end
  
  def other_group_required?
    group_type.to_i < 0
  end
  
  def self.find_prev(project_id, exposition_id)
    project = where(:exposition_id => exposition_id).
              includes(:exposition, :authors).
              order("created_at desc")
          
    project.where(["id > ?", project_id]).last || project.last
  end
  
  def self.find_next(project_id, exposition_id)
    project = where(:exposition_id => exposition_id).
              includes(:exposition, :authors).
              order("created_at desc")
          
    project.where(["id < ?", project_id]).first || project.first
  end
  
  def self.with_extra_needs
    where <<SQL
        requirements is not null or lab_gear is not null or sockets_count > 0 or 
        needs_projector_reason is not null or needs_screen_reason is not null or 
        needs_poster_hanger_reason is not null
SQL
  end
  
  def remove_image=(remove)
    self.image = nil if remove == '1'
  end
  
  def fcty_desc
    faculty_desc(faculty) + (other_faculty.present? ? " (#{other_faculty})" : '')
  end
  
  def grp_desc
    group_type_desc(group_type) + (other_group.present? ? " (#{other_group})" : '')
  end
  
  def mode_desc
    expo_mode_desc expo_mode
  end
  
  def filename
    "#{exposition.year}-#{title.gsub(/\W/, '_')}.pdf"
  end
  
  def sumo_robot?
    expo_mode == Conf.expo_modes['ROBOT SUMO']
  end
  
  private
  
  def authors_names
    authors.map(&:name).join ', '
  end
  
  def identifier
    "#{exposition.year}-#{id}"
  end
  
  def must_have_at_least_one_author
    errors.add(:author_ids, I18n.t('errors.messages.blank')) if authors.empty?
  end
end
