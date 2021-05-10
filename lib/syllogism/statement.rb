class Syllogism
  class Statement
    ATOMIC_TYPES = [
      Quantity,
      GeneralTerm,
      Verb,
      Negation,
      SingularTerm,
      Unknown
    ].freeze

    attr_reader :errors

    def initialize(string)
      @errors = []
      @string = string
      @atoms = string.split(" ").map { |word| atomize(word) }
    end

    def wff?
      known_atoms? && verb?
    end

    private

    attr_reader :atoms, :string

    def atomize(word)
      ATOMIC_TYPES.map do |type|
        type.new(word)
      end.detect { |atom| atom.match? }
    end

    def known_atoms?
      unknown = atoms.select { |atom| atom.instance_of?(Unknown) }
      if unknown.any?
        unknown.each do |atom|
          errors.push("'#{atom.value}' is an unknown atom")
        end

        false
      else
        true
      end
    end

    def verb?
      if atoms.any? { |atom| atom.instance_of?(Verb) }
        true
      else
        errors.push("'#{string}' does not contain the verb 'is' or 'are'")
        false
      end
    end
  end
end
