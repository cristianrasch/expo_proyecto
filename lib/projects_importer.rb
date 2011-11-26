require 'pathname'

class ProjectsImporter
  def self.import_legacy_projects
    logger = Logger.new(File.join(Rails.root, 'log', 'legacy_projects_import.log'))
    logger.datetime_format = '%d/%m/%Y - %H:%M:%S'
    logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime} #{"="*50}\n #{msg}\n" }
    
    # Exposition.destroy_all if Rails.env.development?
    home_dir = Pathname.new(Conf.backups_dir)

    Dir.glob(home_dir + 'ep[0-9][0-9]').each do |expo_dir|
      year = Date.today.strftime('%Y')[0,2]+expo_dir[-2,2]
      expo = Exposition.find_or_create_by_year(year)
      projects_dir = Pathname.new(expo_dir) + 'proyectos'
      
      Dir.glob(projects_dir + 'EXPO*').each do |prj_dir|
        project_dir = Pathname.new(prj_dir)
        title = (project_dir+'f1').read.fencode
        author = (project_dir+'f2').read.fencode
        subject = (project_dir+'f3').read.fencode
        group_type = group_type = Conf.group_types[(project_dir+'f4').read.rstrip]
        competes_to_win_prizes = (project_dir+'f5').read.rstrip =~ /NO/i ? false : true
        contact = (project_dir+'f6').read.fencode
        expo_mode = Conf.expo_modes[(project_dir+'f8').read.rstrip]
        description = (project_dir+'f9').read.fencode
        faculty = Conf.faculties[(project_dir+'f10').read.rstrip]
        project = expo.projects.build(:title => title, :subject => subject, :group_type => group_type, 
                                      :competes_to_win_prizes => competes_to_win_prizes, :contact => contact, 
                                      :expo_mode => expo_mode, :description => description, 
                                      :faculty => faculty)
        image_file = project_dir + 'foto.jpg'
        project.image = image_file.open if image_file.exist?
        project.authors.build(:name => author)
        begin
          project.save!
        rescue ActiveRecord::RecordInvalid => e
          logger.error([e, "Expo: #{expo.name}", "Project: #{File.basename(project_dir)}", "="*81].join("\n"))
        end
      end
    end
    logger.close
  end
end
