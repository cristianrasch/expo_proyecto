module DateUtils
  def self.included(recipient)
    recipient.extend ClassMethods
    recipient.send :include, InstanceMethods
  end

  module ClassMethods
    def date_writer_for(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |date|
          if date.is_a?(Date)
            write_attribute(attr, date)
          else
            write_attribute(attr, (date.blank? ? nil : format_date(date)))
          end
        end
      end
    end
  end

  module InstanceMethods
    def format_date(date)
      Date.civil(*date.split('/').map(&:to_i).reverse)
    end
  end
end
