class Syllogism
  class Statement
    attr_reader :errors

    def initialize(string)
      @errors = []
      @string = string
    end

    def wff?
      verb?
    end

    private

    attr_reader :string

    def verb?
      if string.include?("is")
        true
      else
        errors.push("'#{string}' does not contain the verb 'is'")
        false
      end
    end
  end
end
