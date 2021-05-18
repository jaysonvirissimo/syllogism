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
  attr_reader :errors, :statements

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
    statements_are_well_formed? && meets_definition_of_syllogism?
  end

  private

  attr_writer :errors

  def contains_statements?
    if statements.any?
      true
    else
      errors.push("By definition, a syllogism must contain at least one statement")
      false
    end
  end

  def exactly_two_of_each_term?
    if term_histogram.values.all? { |count| count == 2 }
      true
    else
      term_histogram.reject { |_term, count| count == 2 }.each do |term, count|
        errors.push("The term '#{term}' occured #{count} time(s), but should occur exactly twice")
      end

      false
    end
  end

  def forms_a_chain?
    (0...statements.count - 1).map do |index|
      current_statement = statements[index]
      next_statement = statements[index + 1]
      current_terms = current_statement.terms.map(&:value)
      next_terms = next_statement.terms.map(&:value)

      if (current_terms - next_terms).length == 1
        true
      else
        errors.push("'#{current_statement}'' should share exactly one term with '#{next_statement}'")
        false
      end
    end.all?
  end

  def meets_definition_of_syllogism?
    contains_statements? && exactly_two_of_each_term? && forms_a_chain?
  end

  def statements_are_well_formed?
    statements.all? do |statement|
      if statement.wff?
        true
      else
        statement.errors.each { |error| errors.push(error) }
        false
      end
    end
  end

  def term_histogram
    statements.flat_map(&:terms).map(&:value).each_with_object(Hash.new(0)) do |value, hash|
      hash[value] += 1
    end
  end
end
