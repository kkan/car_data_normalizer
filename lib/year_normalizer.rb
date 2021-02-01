# frozen_string_literal: true

class YearNormalizer
  MIN_VALID_YEAR = 1900
  MAX_VALID_YEARS_FROM_NOW = 2

  def initialize(year_input)
    @year_input = year_input
  end

  def process
    year = @year_input.to_i

    valid_year?(year) ? year : @year_input
  end

  private

  def valid_year?(year)
    (MIN_VALID_YEAR..max_valid_year).include?(year)
  end

  def max_valid_year
    Time.now.year + MAX_VALID_YEARS_FROM_NOW
  end
end
