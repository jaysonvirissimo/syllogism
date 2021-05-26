class Syllogism
  class Term < Atom
    attr_writer :distributed, :starred

    def distributed?
      !!@distributed
    end

    def starred?
      !!@starred
    end
  end
end
