class Syllogism
  class Statement
    SINGULAR_TERMS = ("a".."z").freeze
    QUALITIES = ["not"].freeze
    QUANTITIES = ["all", "some", "no"].freeze
    VERBS = ["is", "are"].freeze

    attr_reader :errors

    def initialize(string)
      @errors = []
      @string = string
      @atoms = string.split(" ")
    end

    def wff?
      known_atoms? && verb?
    end

    private

    attr_reader :atoms, :string

    def known_atoms?
      atoms.map do |atom|
        if atom.length > 1
          if (QUALITIES + QUANTITIES + VERBS).include?(atom.downcase)
            true
          else
            errors.push("'#{atom}' is an unknown atom")
            false
          end
        elsif GeneralTerm.new(atom).match? || SINGULAR_TERMS.include?(atom)
          true
        else
          errors.push("'#{atom}' is an unknown atom")
          false
        end
      end.all?
    end

    def verb?
      if (atoms & VERBS).empty?
        errors.push("'#{string}' does not contain the verb 'is'")
        false
      else
        true
      end
    end
  end
end
