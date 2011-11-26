require 'iconv'

module StringExt
  def fencode
    Iconv.iconv('utf-8', 'iso-8859-1', self.rstrip).first
  end
end

class String
  include StringExt
end
