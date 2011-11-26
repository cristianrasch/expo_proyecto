# encoding: utf-8

require "iconv"
require "csv"

class ProjectsExporter
  class << self
    def export_legacy_projects
      home_dir = File.expand_path(Conf.backups_dir)

      CSV.open("#{File.expand_path '~/Desktop/proyectos.csv'}", "wb") do |csv|
        csv << ['Año', 'Proyecto', 'Autor(es)']
        
        Dir.glob(File.join(home_dir, "ep[0-9][0-9]")).each do |expo_dir|
          projects_dir, title, author = File.join(expo_dir, "proyectos"), nil, nil
          year = Date.today.strftime("%Y")[0,2]+expo_dir[-2,2]
          
          Dir.glob(File.join(projects_dir, "EXPO*")).each do |project_dir|
            File.open(File.join(project_dir, "f1")) { |f| title = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
            File.open(File.join(project_dir, "f2")) { |f| author = Iconv.iconv("utf-8", "iso-8859-1", f.read.rstrip).first }
              csv << [year, title, author]
          end
        end
      end
    end
  end
end
