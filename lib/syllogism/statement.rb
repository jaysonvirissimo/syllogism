class Syllogism
  class Statement
    attr_reader :atoms, :errors

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

    def predicate
      terms.last
    end

    def subject
      terms.first
    end

    def to_s
      atoms.map(&:value).join(" ")
    end

    def wff?
      known_atoms? && verb? && known_formula?
    end

    private

    ATOMIC_TYPES = [
      All,
      No,
      Some,
      GeneralTerm,
      Verb,
      Negation,
      SingularTerm,
      Unknown
    ].freeze

    TERM_TYPES = [GeneralTerm, SingularTerm].freeze

    def known_atoms?
      unknown.none?
    end

    def known_formula?
      WffChecker.new(self).any?
    end

    def terms
      @terms ||= atoms.select { |atom| TERM_TYPES.include?(atom.class) }
    end

    def unknown
      @unknown ||= atoms.select do |atom|
        atom.instance_of?(Unknown)
      end.tap do |atoms|
        atoms.each { |atom| errors.push("'#{atom.value}' is an unknown atom") }
      end
    end

    def verb?
      if atoms.any? { |atom| atom.instance_of?(Verb) }
        true
      else
        errors.push("'#{self}' does not contain the verb 'is' or 'are'")
        false
      end
    end
  end
end
