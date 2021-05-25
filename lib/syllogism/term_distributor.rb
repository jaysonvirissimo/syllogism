class Syllogism
  class TermDistributor
    def initialize(statement)
      @atoms = statement.atoms
      @current = nil
      @position = 0
      @terms = statement.terms
    end

    def call
      atoms.each_with_index do |atom, index|
        self.current, self.position = atom, index
        if term?
          atom.distributed = should_distribute?
        end
      end
    end

    private

    attr_accessor :current, :position
    attr_reader :atoms, :terms

    def anywhere_after_no?
      preceeding_types.include?(No)
    end

    def immediately_after_all?
      immediate_predecessor == All
    end

    def immediately_after_not?
      immediate_predecessor == Negation
    end

    def immediate_predecessor
      preceeding_types.last
    end

    def preceeding_types
      atoms.take(position).map(&:class)
    end

    def should_distribute?
      immediately_after_all? || immediately_after_not? || anywhere_after_no?
    end

    def term?
      terms.include?(current)
    end
  end
end
