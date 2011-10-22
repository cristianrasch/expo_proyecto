require "iconv"

class ProjectsImporter
  class << self
    def import_legacy_projects
      Exposition.destroy_all if Rails.env.development?
    
      logger = Logger.new(File.join(Rails.root, "log", "legacy_projects_import.log"))
      logger.datetime_format = "%d/%m/%Y - %H:%M:%S"
      logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime} #{"="*50}\n #{msg}\n" }
      home_dir = File.expand_path(Conf.backups_dir)

      Dir.glob(File.join(home_dir, "ep[0-9][0-9]")).each do |expo_dir|
        year = Date.today.strftime("%Y")[0,2]+expo_dir[-2,2]
        expo = Exposition.find_or_create_by_year(year)
        
        projects_dir = File.join(expo_dir, "proyectos")
        title, author, subject, group_type = nil, nil, nil, nil
        competes_to_win_prizes, contact, expo_mode, description, faculty = nil, nil, nil, nil, nil
        Dir.glob(File.join(projects_dir, "EXPO*")).each do |project_dir|
          File.open(File.join(project_dir, "f1")) { |f| title = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
          File.open(File.join(project_dir, "f2")) { |f| author = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
          File.open(File.join(project_dir, "f3")) { |f| subject = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
          File.open(File.join(project_dir, "f4")) { |f| group_type = Conf.group_types[f.read.rstrip] }
          File.open(File.join(project_dir, "f5")) { |f| competes_to_win_prizes = f.read.rstrip =~ /NO/i ? false : true }
          File.open(File.join(project_dir, "f6")) { |f| contact = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
          File.open(File.join(project_dir, "f8")) { |f| expo_mode = Conf.expo_modes[f.read.rstrip] }
          File.open(File.join(project_dir, "f9")) { |f| description = Iconv.iconv("utf-8", "iso-8859-1", f.read.strip).first }
          File.open(File.join(project_dir, "f10")) { |f| faculty = Conf.faculties[f.read.rstrip] }
          
          project = expo.projects.build(:title => title, :subject => subject, :group_type => group_type, 
                                        :competes_to_win_prizes => competes_to_win_prizes, :contact => contact, 
                                        :expo_mode => expo_mode, :description => description, 
                                        :faculty => faculty)
          image_file = File.join(project_dir, "foto.jpg")
          project.image = File.open(image_file) if File.exists?(image_file)
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
end
