class Syllogism
  class GeneralTerm < Term
    def match?
      GENERAL_TERM_VALUES.include?(value)
    end

    private

    GENERAL_TERM_VALUES = ("A".."Z").freeze
  end
end
