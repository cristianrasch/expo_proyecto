module ApplicationHelper
  def not_found(klass)
    content_tag :em do
      "No se encontraron #{klass.model_name.human.pluralize}"
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')".html_safe)
  end
  
  def expos_menu
    expos = Exposition.order("year desc").all
    lis = []
    
    if expos.empty?
      lis = content_tag(:li, link_to("Nueva".html_safe, new_exposition_path))
    else
      lis = expos.map do |expo|
        content_tag(:li) do
          link_to expo.name, exposition_path(expo.year)
        end
      end.join.html_safe
    end
    
    content_tag :ul, lis
  end
end
