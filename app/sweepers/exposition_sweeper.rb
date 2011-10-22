class ExpositionSweeper < ActionController::Caching::Sweeper
  observe Exposition
  
  def after_create(exposition)
    expire_expositions_list
  end
  
  def after_destroy(exposition)
    expire_expositions_list
  end
  
  private
  
  def expire_expositions_list
    expire_fragment("expositions_list")
  end
end
