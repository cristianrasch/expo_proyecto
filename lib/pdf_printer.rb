module PDFPrinter
  class << self
    include ProjectUtils
    include Prawn::Measurements
  
    def print_pdfs(projects)
      doc = Prawn::Document.new(:page_size => [cm2pt(13.5), cm2pt(20)], :margin => 5)
      
      projects.each_with_index do |pr, i| 
        pr.to_pdf doc
        doc.start_new_page if i < projects.length - 1
      end
      
      doc.render
    end
  
    def print_tags(projects)
      doc = Prawn::Document.new(:page_size => 'A4', :margin => [cm2pt(2), cm2pt(0.8)])
      box = doc.margin_box
      x, y = box.left, box.top
      row, col = 0, 0
      spacer, last_row_y_offset = cm2pt(0.1), cm2pt(0.5)
      
      projects.each_with_index do |pr, i|
        pr.authors.each do |author|
          tag_arr = [{:text => author.name, :size => 10, :styles => [:bold]}, 
                     {:text => "\n"+(pr.other_faculty || faculty_desc(pr.faculty)), :size => 8}, 
                     {:text => "\n"+pr.subject, :size => 8}]
        
          doc.formatted_text_box tag_arr, :at => [x, y], :width => TAG_WIDTH, :height => TAG_HEIGHT, 
                                          :align => :center, :valign => :center, :overflow => :shrink_to_fit
          
          x += TAG_WIDTH + spacer*(col+1)
          col += 1
          
          if (col%3).zero?
            col = 0
            x = box.left
            y -= TAG_HEIGHT + (row == 8 ? last_row_y_offset : 0)
            row += 1
            
            if (row%10).zero? && i < projects.length - 1
              doc.start_new_page
              y = box.top
            end
          end
        end
      end
        
      doc.render
    end
    
    def print_requirements(projects)
      doc = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
      cells = [[Project.model_name.human.humanize]]
      cells.first.concat %w(requirements lab_gear sockets_count 
                            needs_projector needs_screen 
                            needs_poster_hanger).map { |attr| Project.human_attribute_name attr }
      
      projects.each do |pr|
        cells << [pr.title, pr.requirements, pr.lab_gear, pr.sockets_count.zero? ? nil : pr.sockets_count,
                  pr.needs_projector_reason, pr.needs_screen_reason, pr.needs_poster_hanger_reason]
      end
      
      doc.table(cells, :cell_style => { :size => 10, :width => doc.margin_box.width/cells.first.length }) do
        row(0).style :font_style => :bold, :align => :center
      end
      
      doc.render
    end
  end
    
  private
  
  TAG_WIDTH = cm2pt(6.4)
  TAG_HEIGHT = cm2pt(2.51)
end
