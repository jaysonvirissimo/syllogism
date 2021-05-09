class Syllogism
  class Verb < Atom
    VERB_VALUES = ["is", "are"].freeze

    def match?
      VERB_VALUES.include?(value)
    end
  end
end
