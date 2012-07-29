class ExpositionSweeper < ActionController::Caching::Sweeper
  observe Exposition
  
  #def after_save(exposition)
  #end
  
  #def after_destroy(exposition)
  #  after_save(exposition)
  #end
end