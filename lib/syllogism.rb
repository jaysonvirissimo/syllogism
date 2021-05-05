require "syllogism/version"

class Syllogism
  class Error < StandardError; end

  attr_reader :errors

  def [](*statements)
    new(*statements)
  end

  def initialize(*statements)
    @errors = []
    @statements = statements
  end

  def premises
    @premises ||= statements.take(statements.length - 1)
  end

  def conclusion
    @conclusion ||= statements.last
  end

  def valid?
    statements.each { |statement| verb?(statement) }

    errors.empty?
  end

  private

  attr_reader :statements
  attr_writer :errors

  def verb?(statement)
    unless statement.include?("is")
      errors.push("'#{statement}' does not contain the verb 'is'")
    end
  end
end
