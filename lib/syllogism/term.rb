class Syllogism
  class Term < Atom
    attr_writer :distributed

    def distributed?
      !!@distributed
    end
  end
end
