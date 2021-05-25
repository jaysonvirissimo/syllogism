class Syllogism
  class TermDistributor
    def initialize(statement)
      @statement = statement
    end

    def call
      atoms.each_with_index do |atom, index|
        if atom == statement.subject || atom == statement.predicate
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

    private

    attr_reader :statement

    SINGULARLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [All, Negation].freeze
    MULTIPLY_DISTRIBUTABLE_PREDECESSOR_TYPES = [No].freeze

    def atoms
      statement.atoms
    end
  end
end
