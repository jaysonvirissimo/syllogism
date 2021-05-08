class Syllogism
  class GeneralTerm < Atom
    GENERAL_TERM_VALUES = ("A".."Z").freeze

    def match?
      GENERAL_TERM_VALUES.include?(value)
    end
  end
end