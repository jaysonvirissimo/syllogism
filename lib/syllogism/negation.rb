class Syllogism
  class Negation < Atom
    NEGATION_VALUE = "not".freeze

    def match?
      NEGATION_VALUE.casecmp?(value)
    end
  end
end
