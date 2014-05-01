class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

class Numeric
   def radians_to_vec2
       CP::Vec2.new(Math::cos(self), Math::sin(self))
   end
end
