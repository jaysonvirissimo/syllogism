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

    def self.atomize(word)
      ATOMIC_TYPES.map do |type|
        type.new(word)
      end.detect { |atom| atom.match? }
    end

    def self.parse(string)
      new(string.split(" ").map { |word| atomize(word) })
    end

    def initialize(atoms)
      @atoms = atoms
      @errors = []
    end

    def to_s
      atoms.map(&:value).join(" ")
    end

    def wff?
      known_atoms? && verb?
    end

    private

    attr_reader :atoms

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
        errors.push("'#{to_s}' does not contain the verb 'is' or 'are'")
        false
      end
    end
  end
end
