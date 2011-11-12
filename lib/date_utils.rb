module DateUtils
  def self.included(recipient)
    recipient.extend ClassMethods
  end

  module ClassMethods
    def date_writer_for(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |date|
          if date.present?
            d = date.is_a?(String) ? Date.parse(date) : date
            write_attribute attr, d
          end
        end
      end
    end
    
    def datetime_writer_for(*attrs)
      attrs.each do |attr|
        define_method("#{attr}=") do |datetime|
          if datetime.present?
            dt = datetime.is_a?(String) ? Time.zone.parse(datetime) : datetime
            write_attribute attr, dt
          end
        end
      end
    end
  end
end
