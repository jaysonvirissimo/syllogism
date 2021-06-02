class Syllogism
  class WffChecker
    def initialize(statement)
      @statement = statement
    end

    def any?
      formula && !formula.empty?
    end

    def formula
      @formula ||= WELL_FORMED_FORMULAS.find do |formula_type|
        atom_types == formula_type
      end.to_s
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
