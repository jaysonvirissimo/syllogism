class Syllogism
  class SingularTerm < Atom
    SINGULAR_TERM_VALUES = ("a".."z").freeze

    def match?
      SINGULAR_TERM_VALUES.include?(value)
    end
  end
end
