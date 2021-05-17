class Syllogism
  class SingularTerm < Term
    def match?
      SINGULAR_TERM_VALUES.include?(value)
    end

    private

    SINGULAR_TERM_VALUES = ("a".."z").freeze
  end
end
