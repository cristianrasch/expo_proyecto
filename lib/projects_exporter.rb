# encoding: utf-8

require 'pathname'
require 'csv'

class ProjectsExporter
  def self.export_legacy_projects
    home_dir = Pathname.new(Conf.backups_dir)

    CSV.open("#{Pathname.new('~/Desktop/proyectos.csv').expand_path}", 'wb') do |csv|
      csv << ['Año', 'Proyecto', 'Autor(es)']
      
      Dir.glob(home_dir + 'ep[0-9][0-9]').each do |expo_dir|
        projects_dir = Pathname.new(expo_dir) + 'proyectos'
        year = Date.today.strftime('%Y')[0,2]+expo_dir[-2,2]
        
        Dir.glob(projects_dir + 'EXPO*').each do |prj_dir|
          project_dir = Pathname.new(prj_dir)
          title = (project_dir+'f1').read.fencode
          author = (project_dir+'f2').read.fencode
          csv << [year, title, author]
        end
      end
    end
  end
end
