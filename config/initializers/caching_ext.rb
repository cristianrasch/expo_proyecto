module CachingExt
  extend ActiveSupport::Concern
  
  module ClassMethods
    def cache_key
      Digest::MD5.hexdigest "#{maximum(:updated_at)}.try(:to_i)-#{count}"
    end
  end
end

class ActiveRecord::Base
  include CachingExt
end