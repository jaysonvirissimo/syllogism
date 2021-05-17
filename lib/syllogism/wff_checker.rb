class Syllogism
  class WffChecker
    def initialize(statement)
      @statement = statement
    end

    def any?
      WELL_FORMED_FORMULAS.any? do |formula|
        atom_types == formula
      end
    end

    private

    attr_reader :statement

    WELL_FORMED_FORMULAS = [
      [All, GeneralTerm, Verb, GeneralTerm],
      [Some, GeneralTerm, Verb, GeneralTerm],
      [SingularTerm, Verb, GeneralTerm],
      [SingularTerm, Verb, SingularTerm],
      [No, GeneralTerm, Verb, GeneralTerm],
      [Some, GeneralTerm, Verb, Negation, GeneralTerm],
      [SingularTerm, Verb, Negation, GeneralTerm],
      [SingularTerm, Verb, Negation, SingularTerm]
    ].freeze

    def atoms
      statement.atoms
    end

    def atom_types
      @atom_types ||= atoms.map { |atom| atom.class }
    end
  end
end
