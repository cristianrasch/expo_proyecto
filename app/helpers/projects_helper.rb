# encoding: utf-8

module ProjectsHelper
  include ProjectUtils

  %w{faculties group_types expo_modes}.each do |method|
    define_method("#{method.singularize}_options") do
      Conf.send(method).to_a.map { |arr|
        [downcase_accented_vowels(arr.first.humanize), arr.last]
      }.sort {|arr1, arr2| arr1.first <=> arr2.first}
    end
  end
  
  def escape_emails(contact)
    email_reg_exp = Regexp.new(Conf.email_reg_exp)
    matches = contact.scan(email_reg_exp)
    matches.inject(contact) { |a, e| a.gsub(e, e.gsub('@', '__AT__')) }
  end
end
