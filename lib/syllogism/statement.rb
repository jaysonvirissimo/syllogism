class Syllogism
  class Statement
    attr_reader :atoms, :errors

    def self.[](string)
      parse(string)
    end

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

    def distribute
      atoms.each_with_index do |atom, index|
        if TERM_TYPES.include?(atom.class)
          predecessor = atoms[index - 1].class
          subsequent_classes = atoms.take(index).map(&:class)

          atom.distributed = if SINGULARLY_DISTRIBUTABLE_PREDECESSOR_TYPES.include?(predecessor)
            true
          elsif (MULTIPLY_DISTRIBUTABLE_PREDECESSOR_TYPES & subsequent_classes).length.positive?
            true
          else
            false
          end
        end
      end
    end

    def predicate
      terms.last
    end

    def subject
      terms.first
    end

    def terms
      @terms ||= atoms.select { |atom| TERM_TYPES.include?(atom.class) }
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

    SINGULARLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [All, Negation].freeze
    MULTIPLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [No].freeze

    TERM_TYPES = [GeneralTerm, SingularTerm].freeze

    def known_atoms?
      unknown.none?
    end

    def known_formula?
      WffChecker.new(self).any?
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
