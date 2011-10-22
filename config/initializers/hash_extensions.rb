if RUBY_VERSION =~ /1.8/
  class Hash
    def key(value)
      arr = find {|k, v| v == value}
      arr.first if arr
    end
  end
end
