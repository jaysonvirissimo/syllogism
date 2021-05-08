class Syllogism
  class Atom
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def match?
      false
    end
  end
end
