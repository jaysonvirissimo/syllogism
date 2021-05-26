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
require "syllogism/term_distributor"
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
    statements_are_well_formed? &&
      meets_definition_of_syllogism? &&
      distribute_terms &&
      star_premises &&
      star_conclusion &&
      passes_star_test?
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

  def distribute_terms
    statements.each(&:distribute) && true
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

  def every_general_term_is_starred_exactly_once
    statements.each_with_object(Hash.new(0)) do |statement, stars|
      statement.general_terms.each do |general_term|
        stars[general_term.value] += 1 if general_term.starred?
      end
    end.values.all? { |star_count| star_count == 1 }
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

  # See Harry Gensler's paper, _A simplified decision procedure for categorical syllogisms._
  # https://projecteuclid.org/journals/notre-dame-journal-of-formal-logic/volume-14/issue-4/A-simplified-decision-procedure-for-categorical-syllogisms/10.1305/ndjfl/1093891100.full
  def passes_star_test?
    every_general_term_is_starred_exactly_once &&
      there_is_exactly_one_star_on_the_right_hand_side
  end

  def star_premises
    premises.each do |premise|
      premise.terms.each do |term|
        term.starred = term.distributed?
      end
    end
  end

  def star_conclusion
    conclusion.terms.each do |term|
      term.starred = !term.distributed?
    end
  end

  def statements_are_well_formed?
    statements.map do |statement|
      if statement.wff?
        true
      else
        statement.errors.each { |error| errors.push(error) }
        false
      end
    end.all?
  end

  def term_histogram
    statements.flat_map(&:terms).map(&:value).each_with_object(Hash.new(0)) do |value, hash|
      hash[value] += 1
    end
  end

  def there_is_exactly_one_star_on_the_right_hand_side
    statements.map(&:predicate).count(&:starred?) == 1
  end
end
