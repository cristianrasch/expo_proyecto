class ActivitySweeper < ActionController::Caching::Sweeper
  observe Activity
  
  def after_save(activity)
    expire_page root_path
  end
  
  def after_destroy(activity)
    after_save(activity)
  end
end