class Syllogism
  class Some < Quantity
    VALUE = "some".freeze

    def match?
      VALUE.casecmp?(value)
    end
  end
end
