require "syllogism/atom"
require "syllogism/general_term"
require "syllogism/negation"
require "syllogism/quantity"
require "syllogism/singular_term"
require "syllogism/unknown"
require "syllogism/verb"
require "syllogism/statement"
require "syllogism/version"

class Syllogism
  attr_reader :errors

  def [](*raw_statements)
    new(*raw_statements)
  end

  def initialize(*raw_statements)
    @errors = []
    @statements = raw_statements.map do |raw_statement|
      Statement.new(raw_statement)
    end
  end

  def premises
    @premises ||= statements.take(statements.length - 1)
  end

  def conclusion
    @conclusion ||= statements.last
  end

  def valid?
    statements.all? do |statement|
      if statement.wff?
        true
      else
        statement.errors.each { |error| errors.push(error) }
        false
      end
    end
  end

  private

  attr_reader :statements
  attr_writer :errors
end
