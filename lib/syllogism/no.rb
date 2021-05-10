class Syllogism
  class No < Quantity
    VALUE = "no".freeze

    def match?
      VALUE.casecmp?(value)
    end
  end
end
