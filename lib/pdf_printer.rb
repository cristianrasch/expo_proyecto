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
      
      projects_file = File.join(Dir.tmpdir, 'proyectos.pdf')
      doc.render_file projects_file
      projects_file
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
        
      tags_file = File.join(Dir.tmpdir, 'etiquetas.pdf')
      doc.render_file tags_file
      tags_file
    end
    
    def print_requirements(projects)
      doc = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
      cells = [[Project.model_name.human.humanize, Project.human_attribute_name(:requirements), 
                Project.human_attribute_name(:lab_gear), Project.human_attribute_name(:sockets_count), 
                Project.human_attribute_name(:needs_projector), Project.human_attribute_name(:needs_screen),      
                Project.human_attribute_name(:needs_poster_hanger)]]
      
      projects.each do |pr|
        cells << [pr.title, pr.requirements, pr.lab_gear, pr.sockets_count.zero? ? nil : pr.sockets_count,
                  pr.needs_projector_reason, pr.needs_screen_reason, pr.needs_poster_hanger_reason]
      end
      
      doc.table(cells, :cell_style => { :size => 10, :width => doc.margin_box.width/cells.first.length }) do
        row(0).style :font_style => :bold, :align => :center
      end
      
      requirements_file = File.join(Dir.tmpdir, 'requisitos.pdf')
      doc.render_file requirements_file
      requirements_file
    end
  end
  
  private
  
  TAG_WIDTH = cm2pt(6.4)
  TAG_HEIGHT = cm2pt(2.51)
end
