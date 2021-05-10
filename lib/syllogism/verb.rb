class Syllogism
  class Verb < Atom
    VERB_VALUES = ["is", "are"].freeze

    def match?
      VERB_VALUES.include?(value.downcase)
    end
  end
end
