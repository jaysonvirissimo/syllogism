class Syllogism
  class Statement
    ATOMIC_TYPES = [GeneralTerm, SingularTerm].freeze
    QUALITIES = ["not"].freeze
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
          if (QUALITIES + VERBS).include?(atom.downcase) || Quantity.new(atom).match?
            true
          else
            errors.push("'#{atom}' is an unknown atom")
            false
          end
        elsif ATOMIC_TYPES.any? { |type| type.new(atom).match? }
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
