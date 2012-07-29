class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project
  
  def after_save(project)
    expire_fragment %r{expos/#{project.exposition.year}/projects/gallery(\?action_suffix=\d+)?}
  end
  
  def after_destroy(project)
    after_save(project)
  end
end