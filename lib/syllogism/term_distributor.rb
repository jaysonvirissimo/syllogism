class Syllogism
  class TermDistributor
    def initialize(statement)
      @statement = statement
    end

    def call
      atoms.each_with_index do |atom, index|
        if atom == statement.subject || atom == statement.predicate
          previous_types = atoms.take(index).map(&:class)
          atom.distributed = should_distribute?(previous_types, atom)
        end
      end
    end

    private

    attr_reader :statement

    SINGULARLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [All, Negation].freeze
    MULTIPLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [No].freeze

    def atoms
      statement.atoms
    end

    def should_distribute?(previous_types, term)
      immediate_predecessor = previous_types.last
      SINGULARLY_DISTRIBUTABLE_PREDECESSOR_TYPES.include?(immediate_predecessor) ||
        (MULTIPLY_DISTRIBUTABLE_PREDECESSOR_TYPES & previous_types).length.positive?
    end
  end
end
