# coding: utf-8

module ProjectUtils
  %w{faculties group_types expo_modes}.each do |method|
    define_method("#{method.singularize}_desc") do |value|
      downcase_accented_vowels(Conf.send(method).key(value).humanize)
    end
  end
  
  private
  
  def downcase_accented_vowels(text)
    text.gsub('Á', 'á').gsub('Ó', 'ó').gsub('Í', 'í')
  end
end
