

class String

  # converts SomeStringLikeThis to some_string_like_this
  def camel_to_underscore
    self.gsub(/[A-Z]|[0-9].*/) { |m| '_' + m.downcase }[1..-1]
  end

  # converts some_string_like_this to SomeStringLikeThis
  def underscore_to_camel
    self.split('_').map{ |w| w.capitalize }.join
  end

end
