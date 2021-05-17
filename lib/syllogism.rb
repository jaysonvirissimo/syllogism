require "syllogism/atom"
require "syllogism/quantity"
require "syllogism/all"
require "syllogism/term"
require "syllogism/general_term"
require "syllogism/negation"
require "syllogism/no"
require "syllogism/singular_term"
require "syllogism/some"
require "syllogism/unknown"
require "syllogism/verb"
require "syllogism/statement"
require "syllogism/version"
require "syllogism/wff_checker"

class Syllogism
  attr_reader :errors

  def self.[](*raw_statements)
    parse(*raw_statements)
  end

  def self.parse(*raw_statements)
    new(raw_statements.map { |raw_statement| Statement.parse(raw_statement) })
  end

  def initialize(statements)
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
