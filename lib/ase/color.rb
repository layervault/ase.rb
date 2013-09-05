# Nice little wrapper that lets us easily perform some functions on a
# given color.
class ASE
  class Color
    def self.factory(mode, *args)
      # const_get(mode).new(*args)
      eval("ASE::Color::#{mode}").new(*args)
    end
  end
end