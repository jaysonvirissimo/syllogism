class Syllogism
  class All < Quantity
    VALUE = "all".freeze

    def match?
      VALUE.casecmp?(value)
    end
  end
end
