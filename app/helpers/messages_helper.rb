module MessagesHelper
  def link_to_back(source)
    path = case(source)
      when Exposition then exposition_path(source.year)
      when Project then project_path(source)
    end
    
    link_to('Volver', path)
  end
end
