class Syllogism
  class Quantity < Atom
    QUANTITY_VALUES = ["all", "some", "no"].freeze

    def match?
      QUANTITY_VALUES.include?(value)
    end
  end
end
